use tauri::{
  plugin::{Builder, TauriPlugin},
  Manager, Runtime,
};

pub use models::*;

#[cfg(desktop)]
mod desktop;
#[cfg(mobile)]
mod mobile;

mod commands;
mod error;
mod models;

pub use error::{Error, Result};

#[cfg(desktop)]
use desktop::Fullscreen;
#[cfg(mobile)]
use mobile::Fullscreen;

/// Extensions to [`tauri::App`], [`tauri::AppHandle`] and [`tauri::Window`] to access the fullscreen APIs.
pub trait FullscreenExt<R: Runtime> {
  fn fullscreen(&self) -> &Fullscreen<R>;
}

impl<R: Runtime, T: Manager<R>> crate::FullscreenExt<R> for T {
  fn fullscreen(&self) -> &Fullscreen<R> {
    self.state::<Fullscreen<R>>().inner()
  }
}

/// Initializes the plugin.
pub fn init<R: Runtime>() -> TauriPlugin<R> {
  Builder::new("fullscreen")
    .invoke_handler(tauri::generate_handler![commands::ping])
    .setup(|app, api| {
      #[cfg(mobile)]
      let fullscreen = mobile::init(app, api)?;
      #[cfg(desktop)]
      let fullscreen = desktop::init(app, api)?;
      app.manage(fullscreen);
      Ok(())
    })
    .build()
}
