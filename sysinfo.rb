def get_sysinfo

	info_hash = {
		'uptime': Process.clock_gettime(Process::CLOCK_MONOTONIC),
		'os': RUBY_PLATFORM,
		'os2': ENV['OS'],
		'os-gem': OS.report
	}

	return info_hash
end