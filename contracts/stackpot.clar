(define-constant entry-fee u10000000) ;; 10 STX (in microstacks)
(define-constant max-entries u100)
(define-map entries {round: uint} (list 100 principal))
(define-data-var lottery-open bool false)
(define-data-var admin principal tx-sender)
(define-data-var round uint u1)
(define-map winners uint principal)

;; Initialize entries for current round
(map-insert entries {round: u1} (list))

;; Only admin
(define-private (only-admin)
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u100))
    (ok true)))

;; Start new round
(define-public (start-lottery)
  (begin
    (try! (only-admin))
    (map-set entries {round: (var-get round)} (list))
    (var-set lottery-open true)
    (ok true)
  )
)

;; Enter the lottery
(define-public (enter-lottery)
  (let 
    ((current-entries (default-to (list) (map-get? entries {round: (var-get round)}))))
    (begin
      (asserts! (var-get lottery-open) (err u101))
      ;; The user must send the correct entry-fee with the transaction
      (try! (stx-transfer? entry-fee tx-sender (as-contract tx-sender)))
      (asserts! (is-none (index-of current-entries tx-sender)) (err u103))
      (asserts! (< (len current-entries) max-entries) (err u104))
      (let
        ((new-entries (unwrap! (as-max-len? (append current-entries tx-sender) u100) (err u105))))
        (map-set entries {round: (var-get round)} new-entries)
        (ok true)))))

;; End the round and select a winner
(define-public (end-lottery)
  (begin
    (try! (only-admin))
    (asserts! (var-get lottery-open) (err u104))
    (let
      (
        (current-entries (unwrap! (map-get? entries {round: (var-get round)}) (err u105)))
        (count (len current-entries))
      )
      (asserts! (> count u0) (err u106))
      (let
        (
          (seed burn-block-height)
          (random (mod seed count))
          (winner (unwrap! (element-at current-entries random) (err u107)))
          (total-prize (* entry-fee count))
        )
        (begin
          (map-set winners (var-get round) winner)
          (var-set lottery-open false)
          (var-set round (+ (var-get round) u1))
          (map-insert entries {round: (var-get round)} (list))
          (try! (stx-transfer? total-prize (as-contract tx-sender) winner))
          (ok true)
        )
      )
    )
  )
)

;; View current players
(define-read-only (get-entries)
  (ok (map-get? entries {round: (var-get round)}))
)

;; View last winner
(define-read-only (get-winner (r uint))
  (ok (map-get? winners r))
)
