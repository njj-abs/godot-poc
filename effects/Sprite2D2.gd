extends Sprite2D

var draging: bool = false

@onready var gpu_particles_2d = $GPUParticles2D
@onready var gpu_particles_3d = $"../GPUParticles3D"

func _physics_process(_delta):
	if draging:
		position = get_global_mouse_position()
		#gpu_particles_2d.emitting = true
		gpu_particles_3d.emitting = true
	else:
		#gpu_particles_2d.emitting = false
		gpu_particles_3d.emitting = false
