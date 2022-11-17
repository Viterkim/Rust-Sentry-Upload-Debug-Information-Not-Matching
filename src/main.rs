mod custom_sentry;

use crate::custom_sentry::sentry_init;

fn main() {
    let _guard = sentry_init();
    panic!("Panic from custom_sentry")
}
