shader_type canvas_item;

uniform vec2 tile_px_size = vec2(32.0, 32.0);   // size of one tile in pixels
uniform vec2 atlas_px_size = vec2(576.0, 576.0); // size of whole atlas image

uniform float sway_strength = 4.0;
uniform float sway_speed = 2.0;

void vertex() {
	// UV is in 0 to 1 across the whole atlas
	vec2 uv = -UV;

	// Convert UV to pixel coordinates in atlas
	vec2 uv_px = uv * atlas_px_size;

	// Compute tile index inside atlas
	vec2 tile_index = floor(uv_px / tile_px_size);

	// Compute local coordinates within this tile (0..1)
	vec2 local = fract(uv_px / tile_px_size);

	// Base stays still (local.y = 0)
	float top_mask = local.y;

	// Create unique offset per tile
	float id = tile_index.x + tile_index.y * 4096.0;

	// Wind motion
	float wind = sin(TIME * sway_speed + id * 0.35);

	float sway = wind * sway_strength * top_mask;

	VERTEX.x += sway;
}
