(load "./query.scm")
(use slib)
(require 'trace)
(trace unify-match)
(query-driver-loop)
