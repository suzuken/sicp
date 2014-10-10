; q5.2

(controller
  test-n
  (test (op >) (reg product) (reg n))
  (branch (label fact-done))
  (assign t1 (op *) (reg counter) (reg product))
  (assign t2 (op +) (reg counter) (const 1))
  (assing product (reg t1))
  (assign counter (reg t2))
  (goto (label test-n))
  fact-done)
