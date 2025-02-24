extends Moveable

class_name Crate

#var is_dupe = false
#
#func reset_object():
	#super.reset_object()
	#if is_dupe:
		#queue_free()
