class_name ScrollManager
extends Node

# Start scrolling shader
static func start_scroll(node: Node, speed: float = 0.05):
	var mat = node.material
	if mat is ShaderMaterial:
		mat.set_shader_parameter("scroll_speed", speed)

# Stop scrolling shader
static func stop_scroll(node: Node):
	var mat = node.material
	if mat is ShaderMaterial:
		mat.set_shader_parameter("scroll_speed", 0.0)
