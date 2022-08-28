environment(ENV.fetch("RACK_ENV", "production"))

port(ENV.fetch("PUMA_PORT", 8080).to_i, "0.0.0.0")

puma_workers = ENV.fetch("PUMA_WORKERS", 0).to_i
workers(puma_workers)

threads_min = ENV.fetch("MIN_THREADS", 0).to_i
threads_max = ENV.fetch("MAX_THREADS", 1).to_i
threads(threads_min, threads_max)

preload_app!
