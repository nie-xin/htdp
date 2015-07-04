;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname simple-editor2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

;; A text editor, we can type text, backspace to delete text, left & right to move, and insert text in any position

;; =================
;; Constants:
(define WIDTH  500)
(define HEIGHT 30)

(define CTR-Y (/ HEIGHT 2))

(define TEXT-SIZE 24)
(define TEXT-COLOR "black")


(define MTS (empty-scene WIDTH HEIGHT))


;; =================
;; Data definitions:

(define-struct ts (t))
;; TextState is (make-ts String Number)
;; interp. the statue of input text 
;; s is the string typed
;; c is the cursor's position (x-coordinate)
(define T1 (make-ts (text "hello" TEXT-SIZE TEXT-COLOR)))
(define T2 (make-ts (text "you can do this" TEXT-SIZE TEXT-COLOR)))

#;
(define (fn-for-text-state ts)
  (... (ts-t ts)))

;; Template rules used:
;; - compound: 1 fields


;; =================
;; Functions:

;; TextState -> TextState
;; run the text editor, stirng with initial text state ts
;; start the world with (main (make-ts "" 0))
;; 
(define (main ts)
  (big-bang ts                        ; TextState
            (to-draw render-text)     ; TextState -> Image
            (on-key  handle-key)))    ; TextState KeyEvent -> TextState



;; TextState -> Image
;; produce the ts at height CTR-Y on the MTS
(check-expect (render-text (make-ts "hello")) (place-image (text "hello" TEXT-SIZE TEXT-COLOR) 
                                                           (/ (image-width (text "hello" TEXT-SIZE TEXT-COLOR)) 2) 
                                                           CTR-Y 
                                                           MTS))

;(define (render-text ts) MTS) ;stub

; Template from TextState
(define (render-text ts)
  (place-image 
   (text (ts-t ts) TEXT-SIZE TEXT-COLOR)
   (/ (image-width (text (ts-t ts) TEXT-SIZE TEXT-COLOR)) 2) 
   CTR-Y
   MTS))



;; TextState KeyEvent -> TextState
;; add input characters to the text displaying
(check-expect (handle-key (make-ts "hello") "a") (make-ts "helloa"))

;(define (handle-key ts key) ts) ;stub

; Template from KeyEvent
(define (handle-key ts key)
  (make-ts (string-append (ts-t ts) key)))