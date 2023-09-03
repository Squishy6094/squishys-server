Lights1 motionline_f3dlite_material_002_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Vtx motionline_000_offset_mesh_layer_5_vtx_0[24] = {
	{{ {-19, -19, -136}, 0, {368, 1008}, {129, 0, 0, 255} }},
	{{ {-19, 19, -136}, 0, {624, 1008}, {129, 0, 0, 255} }},
	{{ {-19, 19, -465}, 0, {624, 752}, {129, 0, 0, 255} }},
	{{ {-19, -19, -465}, 0, {368, 752}, {129, 0, 0, 255} }},
	{{ {19, -19, -136}, 0, {368, 240}, {0, 0, 127, 255} }},
	{{ {-19, 19, -136}, 0, {624, -16}, {0, 0, 127, 255} }},
	{{ {-19, -19, -136}, 0, {368, -16}, {0, 0, 127, 255} }},
	{{ {19, 19, -136}, 0, {624, 240}, {0, 0, 127, 255} }},
	{{ {-19, -19, -465}, 0, {112, 496}, {0, 129, 0, 255} }},
	{{ {19, -19, -136}, 0, {368, 240}, {0, 129, 0, 255} }},
	{{ {-19, -19, -136}, 0, {112, 240}, {0, 129, 0, 255} }},
	{{ {19, -19, -465}, 0, {368, 496}, {0, 129, 0, 255} }},
	{{ {19, 19, -465}, 0, {624, 496}, {0, 127, 0, 255} }},
	{{ {-19, 19, -465}, 0, {880, 496}, {0, 127, 0, 255} }},
	{{ {-19, 19, -136}, 0, {880, 240}, {0, 127, 0, 255} }},
	{{ {19, 19, -136}, 0, {624, 240}, {0, 127, 0, 255} }},
	{{ {-19, -19, -465}, 0, {368, 752}, {0, 0, 129, 255} }},
	{{ {-19, 19, -465}, 0, {624, 752}, {0, 0, 129, 255} }},
	{{ {19, 19, -465}, 0, {624, 496}, {0, 0, 129, 255} }},
	{{ {19, -19, -465}, 0, {368, 496}, {0, 0, 129, 255} }},
	{{ {19, -19, -465}, 0, {368, 496}, {127, 0, 0, 255} }},
	{{ {19, 19, -136}, 0, {624, 240}, {127, 0, 0, 255} }},
	{{ {19, -19, -136}, 0, {368, 240}, {127, 0, 0, 255} }},
	{{ {19, 19, -465}, 0, {624, 496}, {127, 0, 0, 255} }},
};

Gfx motionline_000_offset_mesh_layer_5_tri_0[] = {
	gsSPVertex(motionline_000_offset_mesh_layer_5_vtx_0 + 0, 16, 0),
	gsSP1Triangle(0, 1, 2, 0),
	gsSP1Triangle(0, 2, 3, 0),
	gsSP1Triangle(4, 5, 6, 0),
	gsSP1Triangle(4, 7, 5, 0),
	gsSP1Triangle(8, 9, 10, 0),
	gsSP1Triangle(8, 11, 9, 0),
	gsSP1Triangle(12, 13, 14, 0),
	gsSP1Triangle(12, 14, 15, 0),
	gsSPVertex(motionline_000_offset_mesh_layer_5_vtx_0 + 16, 8, 0),
	gsSP1Triangle(0, 1, 2, 0),
	gsSP1Triangle(0, 2, 3, 0),
	gsSP1Triangle(4, 5, 6, 0),
	gsSP1Triangle(4, 7, 5, 0),
	gsSPEndDisplayList(),
};


Gfx mat_motionline_f3dlite_material_002[] = {
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsSPSetLights1(motionline_f3dlite_material_002_lights),
	gsSPEndDisplayList(),
};

Gfx motionline_000_offset_mesh_layer_5[] = {
	gsSPDisplayList(mat_motionline_f3dlite_material_002),
	gsSPDisplayList(motionline_000_offset_mesh_layer_5_tri_0),
	gsSPEndDisplayList(),
};

Gfx motionline_material_revert_render_settings[] = {
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

