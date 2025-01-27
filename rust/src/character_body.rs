use godot::prelude::*;
use godot::classes::{CharacterBody3D, ICharacterBody3D, RigidBody3D};

/// PenguCharlesIsland's custom CharacterBody3D extension.
/// Includes custom logic for RigidBody collisions.
/// 
/// # API Changes
/// `move_and_slide` now applies a force to any colliders that are in contact with the body.
#[derive(GodotClass)]
#[class(init, base = CharacterBody3D, rename = CharacterBody3DExtension)]
pub struct CharacterBodyExtension {
	/// The speed the body is requesting movement at. Usually modified by sprinting, crouching, etc.  
	/// This determines how much force the body is *trying* to apply.
	#[var] target_speed: f32,

	/// The force to use when pushing RigidBodies.
	#[init(val = 7000f32)]
	#[export] push_force: f32,

	last_collided_with: Vec<Gd<RigidBody3D>>,

	base: Base<CharacterBody3D>,
}

#[godot_api]
impl ICharacterBody3D for CharacterBodyExtension {

}

#[godot_api]
impl CharacterBodyExtension {
	/// Functions the same as standard move and slide, but in addition allows pushing of `RigidBody3D` colliders.
	#[func]
	fn move_and_slide(&mut self, delta: f32) {
		let mut base = self.base_mut();

		// Grab the velocity we had *before* engaging with physics this frame.
		let last_vel = base.get_velocity();

		base.move_and_slide();

		let count = base.get_slide_collision_count();

		// Check for lack of collisions.
		if count <= 0 {
			drop(base);
			self.last_collided_with.clear();
			return;
		}

		// The lost force from any collisions this frame.
		let vel = (last_vel.length() - base.get_velocity().length()) / count as f32;

		drop(base);

		self.last_collided_with = (0..count).filter_map(|i| {
			let col = self.base_mut().get_slide_collision(i).expect("Incorrect count of collisions reported!");
			
			let mut body = col.get_collider()?.try_cast::<RigidBody3D>().ok()?;
			let dir = -col.get_normal();
			let pos = col.get_position() - body.get_global_position();

			body.apply_impulse_ex(dir * vel).position(pos).done();

			if self.last_collided_with.contains(&body) {
				// Continued collisions.
				let vel = self.target_speed * delta * self.push_force;
				
				body.apply_force_ex(dir * vel).position(pos).done();
			}

			Some(body)
		}).collect();
	}
}
