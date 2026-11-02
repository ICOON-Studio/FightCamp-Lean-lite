"""Contract tests for board questions and operator availability controls."""
import copy
import http.client
import importlib.util
import json
import tempfile
import threading
import unittest
from http.server import ThreadingHTTPServer
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[2]
SERVER_PATH = ROOT / "Tools" / "opsboard" / "server.py"
SPEC = importlib.util.spec_from_file_location("opsboard_server_questions_test", SERVER_PATH)
server = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(server)


class QuestionsAvailabilityTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.data = Path(self.temp.name)
        self.questions_path = self.data / "AgentComms" / "questions.json"
        self.roster_path = self.data / "AgentComms" / "roster.json"
        self.questions_path.parent.mkdir(parents=True)
        self.seed = {"_doc": "test", "questions": [{
            "id": "Q-S178-1", "asked": "2026-10-08T00:00:00Z", "session": "S178",
            "text": "Is the app installed?", "options": ["Yes", "Not yet", "Don't know"],
            "answer": None, "note": None, "answered_at": None, "seen_by_claude": False,
        }]}
        self.roster = {
            "claude": {"in_rotation": False, "note": "long historical note" * 30, "changed": "old", "extra": "keep"},
            "codex": {"in_rotation": True, "note": "codex note", "changed": "old", "extra": 17},
            "arena": {"in_rotation": True, "note": "arena history", "changed": "old"},
            "top_level_extra": {"untouched": True},
        }
        self.questions_path.write_text(json.dumps(self.seed, indent=2), encoding="utf-8")
        self.roster_path.write_text(json.dumps(self.roster, indent=2, ensure_ascii=False), encoding="utf-8")
        self.old_questions = server.QUESTIONS_PATH
        self.old_roster = server.ROSTER_PATH
        self.old_agents = server.AGENTS
        server.QUESTIONS_PATH = self.questions_path
        server.ROSTER_PATH = self.roster_path
        server.AGENTS = ("claude", "codex")
        self.httpd = ThreadingHTTPServer(("127.0.0.1", 0), server.Handler)
        self.thread = threading.Thread(target=self.httpd.serve_forever, daemon=True)
        self.thread.start()
        self.port = self.httpd.server_address[1]

    def tearDown(self):
        self.httpd.shutdown()
        self.httpd.server_close()
        self.thread.join(timeout=2)
        server.QUESTIONS_PATH = self.old_questions
        server.ROSTER_PATH = self.old_roster
        server.AGENTS = self.old_agents
        self.temp.cleanup()

    def request(self, method, path, payload=None, raw=None):
        conn = http.client.HTTPConnection("127.0.0.1", self.port, timeout=3)
        body = raw if raw is not None else (json.dumps(payload).encode("utf-8") if payload is not None else None)
        conn.request(method, path, body=body, headers={"Content-Type": "application/json"} if body is not None else {})
        response = conn.getresponse()
        data = response.read()
        conn.close()
        return response.status, data

    def test_get_questions_returns_seed(self):
        status, raw = self.request("GET", "/api/questions")
        self.assertEqual(status, 200)
        self.assertEqual(json.loads(raw), self.seed)

    def test_availability_get_uses_every_roster_agent_key(self):
        status, raw = self.request("GET", "/api/availability")
        self.assertEqual(status, 200)
        self.assertEqual(set(json.loads(raw)), set(self.roster))

    def test_availability_accepts_roster_agent_outside_legacy_constant(self):
        status, _ = self.request("POST", "/api/availability", {"agent": "arena", "available": False})
        self.assertEqual(status, 200)
        saved = json.loads(self.roster_path.read_text(encoding="utf-8"))
        self.assertFalse(saved["arena"]["in_rotation"])
        self.assertIn("operator via board: not available", saved["arena"]["note"])

    def test_answer_saves_valid_option(self):
        status, _ = self.request("POST", "/api/answer", {"id": "Q-S178-1", "answer": "Yes", "note": "verified"})
        self.assertEqual(status, 200)
        row = json.loads(self.questions_path.read_text(encoding="utf-8"))["questions"][0]
        self.assertEqual(row["answer"], "Yes")
        self.assertEqual(row["note"], "verified")
        self.assertTrue(row["answered_at"])
        self.assertFalse(row["seen_by_claude"])

    def test_free_comment_instead_of_an_option_is_saved_as_comment(self):
        ## S188 operator: "i want to be able to not pick and answer, just comment on the opsboard".
        status, _ = self.request("POST", "/api/answer", {"id": "Q-S178-1", "answer": "Maybe - ask me after the video"})
        self.assertEqual(status, 200)
        row = json.loads(self.questions_path.read_text(encoding="utf-8"))["questions"][0]
        self.assertEqual(row["answer"], "Maybe - ask me after the video")
        self.assertTrue(row["comment_only"])

    def test_picked_option_is_not_a_comment(self):
        status, _ = self.request("POST", "/api/answer", {"id": "Q-S178-1", "answer": "Yes"})
        self.assertEqual(status, 200)
        row = json.loads(self.questions_path.read_text(encoding="utf-8"))["questions"][0]
        self.assertFalse(row["comment_only"])

    def test_empty_answer_is_400(self):
        status, _ = self.request("POST", "/api/answer", {"id": "Q-S178-1", "answer": "   "})
        self.assertEqual(status, 400)

    def test_unknown_question_is_404(self):
        status, _ = self.request("POST", "/api/answer", {"id": "missing", "answer": "Yes"})
        self.assertEqual(status, 404)

    def test_oversize_body_is_413(self):
        status, _ = self.request("POST", "/api/answer", raw=b" " * 4001)
        self.assertEqual(status, 413)

    def test_free_text_and_note_are_limited(self):
        ## S232: the 500-char cap was raised (S188 free comments, 8000-char field cap); the 4,000-byte body cap is the
        ## real ceiling - a long comment fits, an oversized one is refused.
        question = self.seed["questions"][0]
        question["options"] = []
        self.questions_path.write_text(json.dumps(self.seed), encoding="utf-8")
        status, _ = self.request("POST", "/api/answer", {"id": question["id"], "answer": "x" * 1500})
        self.assertEqual(status, 200)
        status, _ = self.request("POST", "/api/answer", {"id": question["id"], "answer": "x" * 8001})
        self.assertIn(status, (400, 413))
        status, _ = self.request("POST", "/api/answer", {"id": question["id"], "answer": "valid", "note": "x" * 8001})
        self.assertIn(status, (400, 413))

    def test_availability_flips_and_preserves_every_other_value_atomically(self):
        before = copy.deepcopy(self.roster)
        real_replace = server.os.replace
        with mock.patch.object(server.os, "replace", wraps=real_replace) as replace:
            status, _ = self.request("POST", "/api/availability", {"agent": "claude", "available": True})
        self.assertEqual(status, 200)
        replace.assert_called_once()
        after = json.loads(self.roster_path.read_text(encoding="utf-8"))
        self.assertTrue(after["claude"]["in_rotation"])
        self.assertTrue(after["claude"]["note"].startswith(before["claude"]["note"]))
        self.assertIn("operator via board: available", after["claude"]["note"])
        after["claude"].pop("in_rotation")
        before["claude"].pop("in_rotation")
        after["claude"].pop("note")
        before["claude"].pop("note")
        self.assertEqual(after, before)

    def test_unknown_agent_is_404(self):
        status, _ = self.request("POST", "/api/availability", {"agent": "ghost", "available": True})
        self.assertEqual(status, 404)

    def test_ask_appends_next_id(self):
        import sys
        sys.path.insert(0, str(ROOT / "Tools"))
        import agent_comms
        # S181: the session comes from FIGHTCAMP_SESSION, else the roadmap's "updated" (was: the last question's session).
        with mock.patch.dict("os.environ", {"FIGHTCAMP_SESSION": "S178"}):
            self.assertEqual(agent_comms.ask_question("A new question?", "A|B", self.questions_path), "Q-S178-2")
        saved = json.loads(self.questions_path.read_text(encoding="utf-8"))
        self.assertEqual(saved["questions"][-1]["text"], "A new question?")
        self.assertEqual(saved["questions"][-1]["options"], ["A", "B"])

    def test_ask_takes_the_session_from_the_roadmap(self):
        import re, sys
        sys.path.insert(0, str(ROOT / "Tools"))
        import agent_comms
        updated = json.loads((ROOT / "AgentComms" / "roadmap.json").read_text(encoding="utf-8")).get("updated", "")
        want = re.search(r"(S\d+)", updated).group(1)
        with mock.patch.dict("os.environ", {"FIGHTCAMP_SESSION": ""}):
            self.assertEqual(agent_comms.ask_question("Next?", "", self.questions_path), "Q-%s-1" % want if want != "S178" else "Q-S178-2")

    def test_start_prints_unseen_once_then_keeps_open_questions(self):
        import sys
        sys.path.insert(0, str(ROOT / "Tools"))
        import agent_comms
        row = self.seed["questions"][0]
        row.update(answer="Yes", note="confirmed", answered_at="2026-10-08T01:00:00Z")
        self.questions_path.write_text(json.dumps(self.seed), encoding="utf-8")
        output = []
        agent_comms._consume_board_questions(self.questions_path, output.append)
        self.assertTrue(any("QUESTIONS ANSWERED ON THE BOARD" in line for line in output))
        saved_row = json.loads(self.questions_path.read_text(encoding="utf-8"))["questions"][0]
        self.assertTrue(saved_row["seen_by_claude"])
        second = []
        agent_comms._consume_board_questions(self.questions_path, second.append)
        self.assertFalse(any("QUESTIONS ANSWERED ON THE BOARD" in line for line in second))
        self.assertTrue(any("QUESTIONS STILL OPEN" in line for line in second))

    def test_print_failure_does_not_mark_answer_seen(self):
        import sys
        sys.path.insert(0, str(ROOT / "Tools"))
        import agent_comms
        row = self.seed["questions"][0]
        row.update(answer="Yes", note=None, answered_at="now")
        self.questions_path.write_text(json.dumps(self.seed), encoding="utf-8")
        def fail(_):
            raise RuntimeError("stdout failed")
        with self.assertRaises(RuntimeError):
            agent_comms._consume_board_questions(self.questions_path, fail)
        self.assertFalse(json.loads(self.questions_path.read_text(encoding="utf-8"))["questions"][0]["seen_by_claude"])


if __name__ == "__main__":
    unittest.main()

# Required mutants, each must make at least one test above fail, then be reverted:
# 1. Drop the empty-answer check or the comment_only flag in /api/answer (test_empty_answer_is_400 / comment tests).
# 2. Replace _atomic_json for /api/availability with direct write_text (atomicity assertion).
# 3. In _consume_board_questions, set seen_by_claude and save before emitting rows (test_print_failure...).
# 4. Assign row["in_rotation"] = not available (availability preservation test).
