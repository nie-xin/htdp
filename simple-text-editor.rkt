;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname simple-text-editor) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

;; A text editor, we can type text, backspace to delete text, left & right to move, and insert text in any position

;; =================
;; Constants:
(define WIDTH  700)
(define HEIGHT 30)

(define CTR-Y (/ HEIGHT 2))

(define TEXT-SIZE 24)
(define TEXT-COLOR "black")


(define MTS (empty-scene WIDTH HEIGHT))


;; =================
;; Data definitions:

(define-struct ts (s c))
;; TextState is (make-ts String Natural)
;; interp. the statue of input text 
;; s is the string typed
;; c is the cursor's position (x-coordinate) [0, (string-length s)]
(define T1 (make-ts "hello" (string-length "hello")))
(define T2 (make-ts "you can do this" 5))

#;
(define (fn-for-text-state ts)
  (... (ts-s ts)
       (ts-c ts)))

;; Template rules used:
;; - compound: 2 fields


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
(check-expect (render-text (make-ts "hello" 5)) (place-image (text "hello" TEXT-SIZE TEXT-COLOR) 
                                                           (/ (image-width (text "hello" TEXT-SIZE TEXT-COLOR)) 2) 
                                                           CTR-Y 
                                                           MTS))

;(define (render-text ts) MTS) ;stub

; Template from TextState
(define (render-text ts)
  (place-image 
   (text (ts-s ts) TEXT-SIZE TEXT-COLOR)
   (/ (image-width (text (ts-s ts) TEXT-SIZE TEXT-COLOR)) 2) 
   CTR-Y
   MTS))



;; TextState KeyEvent -> TextState
;; add input characters to the text displaying
(check-expect (handle-key (make-ts "hello" 5) "a") (make-ts "helloa" 6))
(check-expect (handle-key (make-ts "hello" 3) "a") (make-ts "helalo" 4))


(check-expect (handle-key (make-ts "hello" 5) "\b") (make-ts "hell" 4))

(check-expect (handle-key (make-ts "" 0) "\b") (make-ts "" 0))

(check-expect (handle-key (make-ts "hello" 5) "left") (make-ts "hello" 4))
(check-expect (handle-key (make-ts "" 0) "left") (make-ts "" 0))
(check-expect (handle-key (make-ts "hello" 4) "right") (make-ts "hello" 5))
(check-expect (handle-key (make-ts "hello" 5) "right") (make-ts "hello" 5))

;(define (handle-key ts key) ts) ;stub

; Template from KeyEvent
(define (handle-key ts key)
  (cond [(key=? "\b" key) 
         (if (> (string-length (ts-s ts)) 0)
             (make-ts (substring (ts-s ts) 0 (- (string-length (ts-s ts)) 1)) (- (ts-c ts) 1))
             ts)]
        [(key=? "left" key)
         (if (> (ts-c ts) 0)
             (make-ts (ts-s ts) (- (ts-c ts) 1))
             ts)]
        [(key=? "right" key)
         (if (< (ts-c ts) (string-length (ts-s ts)))
             (make-ts (ts-s ts) (+ (ts-c ts) 1))
             ts)]
        [else 
         (make-ts (string-append 
                   (substring (ts-s ts) 0 (ts-c ts)) 
                   key
                   (substring (ts-s ts) (ts-c ts) (string-length (ts-s ts)))) 
                  (+ (ts-c ts) 1))]))