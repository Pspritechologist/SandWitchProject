use godot::prelude::*;

mod character_body;

pub struct SandWitchProjectExtension;

#[gdextension]
unsafe impl ExtensionLibrary for SandWitchProjectExtension { }
