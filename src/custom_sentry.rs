// use sentry::integrations::debug_images::DebugImagesIntegration;
use sentry::{ClientInitGuard, ClientOptions};
use std::env;

fn get_dsn_str() -> String {
    env::var("DSN").unwrap_or_else(|_| panic!("Env DSN not set"))
}

pub fn sentry_init() -> ClientInitGuard {
    // Data Source Name is needed otherwise the transport module gets ignored
    // You cannot use None, you cannot use an empty string, nor an invalid string.
    let dsn = if let Ok(Some(dsn)) = sentry::IntoDsn::into_dsn(get_dsn_str()) {
        dsn
    } else {
        panic!("Could not setup dsn for sentry");
    };

    let sentry_options = ClientOptions {
        dsn: Some(dsn),
        attach_stacktrace: true,
        auto_session_tracking: true,
        ..Default::default()
    };
    // .add_integration(DebugImagesIntegration::default());

    let guard = sentry::init(sentry_options);

    guard
}
