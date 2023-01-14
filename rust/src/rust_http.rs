extern crate anyhow;
extern crate reqwest;
extern crate core;
extern crate serde;
use serde::{Deserialize, Serialize};
use anyhow::{ Result};
use reqwest::header::HeaderMap;
use reqwest_middleware::ClientBuilder;
use reqwest_retry::{RetryTransientMiddleware, policies::ExponentialBackoff};
use core::time::Duration;

#[derive(Deserialize, Serialize)]
pub struct Ip  {
    pub origin: String,
}

#[allow(dead_code)]
#[tokio::main(flavor = "current_thread")]
pub async fn get_item() -> Result<Ip> {
    let retry_policy = ExponentialBackoff::builder().build_with_max_retries(1);
    let api = ClientBuilder::new(reqwest::Client::new())
        .with(RetryTransientMiddleware::new_with_policy(retry_policy))
        .build();
    let url = "http://httpbin.org/ip";
    let mut headers = HeaderMap::new();
    headers.insert("Content-Type", "application/json".parse().unwrap());
    let res = api.get(url).headers(headers).timeout(Duration::from_secs(6)).send().await?.json::<Ip>().await?;
    Ok(res)
}

