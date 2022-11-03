rule {
  # This block will apply to all alerting rules.
  match {
    kind = "alerting"
  }

  annotation "message" {
    severity = "bug"
    required = true
  }

  label "severity" {
    severity = "bug"
    value    = "(P1-Critical|P2-Major|P3-Minor|P4-Warning)"
    required = true
  }

  label "scope" {
    severity = "bug"
    value    = "(cluster|namespace)"
    required = true
  }
}

# Verify if metrics used in rules are present.
prometheus "infratest" {
  uri     = "https://prometheus.infratest.cloud.statcan.ca"
  timeout = "15s"
  include = [ "./prom_rules/*/*_rules.yml" ]
}
prometheus "dev" {
  uri     = "https://prometheus.dev.cloud.statcan.ca"
  timeout = "15s"
  include = [ "./prom_rules/*/*_rules.yml" ]
}
prometheus "test" {
  uri     = "https://prometheus.test.cloud.statcan.ca"
  timeout = "15s"
  include = [ "./prom_rules/*/*_rules.yml" ]
}
prometheus "mgmt" {
  uri     = "https://prometheus.cloud.statcan.ca"
  timeout = "15s"
  include = [ "./prom_rules/*/*_rules.yml" ]
}
prometheus "prod" {
  uri     = "https://prometheus.prod.cloud.statcan.ca"
  timeout = "15s"
  include = [ "./prom_rules/*/*_rules.yml" ]
}





