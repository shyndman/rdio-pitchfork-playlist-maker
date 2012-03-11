def parse_args
  args = {
    :dry_run => false
  }

  ARGV.each do |arg|
    case arg
    when "--dry-run"
      args[:dry_run] = true
    end
  end

  args
end