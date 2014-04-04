# PRIVATE CLASS: do not use directly
class guacamole::repo::debian inherits guacamole::repo {
  apt::source { $source_name:
    ensure      => $::guacamole::repo::ensure,
    location    => $::guacamole::repo::location,
    key         => $::guacamole::repo::key,
    include_src => $::guacamole::repo::include_src,
  }
}
