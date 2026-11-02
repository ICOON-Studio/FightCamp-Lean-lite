"""STAFF1: MH2 export with Creator clothing retained and capped before spawning.

Set MH2_CONFIG to one staff1 JSON. Never run two UE processes concurrently.
No installed Epic source asset is saved by this wrapper.
"""
import os, pathlib

source = pathlib.Path(__file__).with_name('mh2_build.py').read_text()
begin = source.index('def clear_outfits(')
end = source.index('TEXFMT =', begin)
source = source[:begin] + '''
_clothing_textures = []
def clear_outfits(ch, require_preview=False):
    # Keep Creator wardrobe selections, unlike the boxer build. Cap source
    # textures before any character assembly; verify again immediately at spawn.
    global _clothing_textures
    if not _clothing_textures:
        registry = unreal.AssetRegistryHelpers.get_asset_registry()
        registry.scan_paths_synchronous(['/MetaHumanCharacter/Optional/Clothing'], True)
        for data in registry.get_assets_by_path('/MetaHumanCharacter/Optional/Clothing', True):
            if str(data.asset_class_path.asset_name) != 'Texture2D':
                continue
            texture = data.get_asset()
            texture.set_editor_property('max_texture_size', 1024)
            assert texture.get_editor_property('max_texture_size') == 1024
            _clothing_textures.append(texture)
        assert _clothing_textures, 'No garment textures found; refusing spawn'
    for texture in _clothing_textures:
        assert 0 < texture.get_editor_property('max_texture_size') <= 2048
    log('garment_texture_cap', {'max_texture_size': 1024, 'count': len(_clothing_textures),
        'textures': [t.get_path_name() for t in _clothing_textures]})
    if require_preview:
        preview = unreal.get_editor_subsystem(unreal.MetaHumanCharacterEditorSubsystem).get_preview_collection(ch)
        assert preview is not None
        log('outfits_retained', [str(x) for x in preview.default_instance.get_slot_selection_data()
            if str(x.selection.slot_name) == 'Outfits'])

''' + source[end:]
# Inspect all garment components as well as the Body/Face exports.
source = source.replace('actor = sub.spawn_meta_human_actor(ch, True)',
    'sub.assemble_for_preview(ch)\n    actor = sub.spawn_meta_human_actor(ch, True)')
source = source.replace('("MH_Groom_Head", "SKM_Groom_Head_Legacy02")',
    '("MH_Groom_Head", "SKM_Groom_Head_Legacy01", "SKM_Groom_Head_Legacy02")')
source = source.replace('log("groom_components",', '''
    garment_components = []
    for component in actor.get_components_by_class(unreal.SkinnedMeshComponent):
        asset = component.get_skinned_asset()
        if asset:
            garment_components.append({'component': component.get_name(), 'asset': asset.get_path_name(),
                'class': asset.get_class().get_name(), 'methods': [n for n in dir(asset) if 'export' in n or 'mesh' in n]})
            if asset.get_class().get_name() == 'ChaosOutfitAsset':
                body_component = next(c for c in actor.get_components_by_class(unreal.SkeletalMeshComponent)
                                      if c.get_name() == 'Body')
                mesh = unreal.Staff1Export.export_outfit(asset, body_component.get_skeletal_mesh_asset())
                assert mesh is not None, 'Epic outfit skeletal export failed'
                log('outfit_skeleton', str(mesh.get_editor_property('skeleton')))
                log('outfit_export', export_obj(mesh, EXP + '/Outfit.fbx'))
                log('outfit_materials', [str(m.material_slot_name) for m in mesh.materials])
    log('garment_runtime_sizes', {t.get_path_name(): [t.blueprint_get_size_x(), t.blueprint_get_size_y(),
        t.get_editor_property('max_texture_size')] for t in _clothing_textures})
    log('garment_components', garment_components)
    log("groom_components",''')
exec(compile(source, __file__, 'exec'))
