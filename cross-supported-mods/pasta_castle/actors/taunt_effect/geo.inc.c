#include "src/game/envfx_snow.h"

const GeoLayout taunt_effect_geo[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_SWITCH_CASE(0, geo_switch_anim_state),
		GEO_OPEN_NODE(),
			GEO_NODE_START(),
			GEO_OPEN_NODE(),
				GEO_DISPLAY_LIST(LAYER_ALPHA, taunt_effect_000_displaylist_mesh_layer_4),
			GEO_CLOSE_NODE(),
		GEO_CLOSE_NODE(),
		GEO_DISPLAY_LIST(LAYER_ALPHA, taunt_effect_material_revert_render_settings),
	GEO_CLOSE_NODE(),
	GEO_END(),
};
