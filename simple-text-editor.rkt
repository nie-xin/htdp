;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname simple-text-editor) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

;; A simple text editor that can display input text, 
;; use backspace to delete text, left & right to move, and insert text in any position

;; =================
;; Constants:
(define WIDTH  700)
(define HEIGHT 30)

(define CTR-Y (/ HEIGHT 2))

(define TEXT-SIZE 24)
(define TEXT-COLOR "black")

(define CURSOR (line 0 HEIGHT "red"))


(define MTS (empty-scene WIDTH HEIGHT))


;; =================
;; Data definitions:

(define-struct ts (s c))
;; TextState is (make-ts String Natural)
;; interp. the statue of input text 
;; s is the input string
;; c is the cursor's position (x-coordinate) [0, (string-length s)],it indicates the next string insertion position as well
(define T1 (make-ts "hello" 5))
(define T2 (make-ts "you can do this" 3))
#;
(define (fn-for-text-state ts)
  (... (ts-s ts)
       (ts-c ts)))

;; Template rules used:
;; - compound: 2 fields


;; =================
;; Functions:

;; TextState -> TextState
;; run the text editor, starting with initial text state ts (empty string and cursor x-postion 0)
;; start the world with (main (make-ts "" 0))
;; 
(define (main ts)
  (big-bang ts                        ; TextState
            (to-draw render-text)     ; TextState -> Image
            (on-key  handle-key)))    ; TextState KeyEvent -> TextState



;; TextState -> Image
;; Display the text at height of CTR-Y on the MTS with a cursor
(check-expect (render-text (make-ts "hello" 5)) (place-image 
                                                 (overlay/offset
                                                  CURSOR
                                                  (- (/ (image-width (text "hello" TEXT-SIZE TEXT-COLOR)) 2)) 0
                                                  (text "hello" TEXT-SIZE TEXT-COLOR)) 
                                                 (/ (image-width (text "hello" TEXT-SIZE TEXT-COLOR)) 2) 
                                                 CTR-Y 
                                                 MTS))
(check-expect (render-text (make-ts "hello" 3)) (place-image 
                                                 (overlay/offset
                                                  CURSOR
                                                  (- (/ (image-width (text "hel" TEXT-SIZE TEXT-COLOR)) 2)) 0
                                                  (text "hello" TEXT-SIZE TEXT-COLOR)) 
                                                 (/ (image-width (text "hello" TEXT-SIZE TEXT-COLOR)) 2) 
                                                 CTR-Y 
                                                 MTS))

;(define (render-text ts) MTS) ;stub

; Template from TextState
(define (render-text ts)
  (place-image 
   (overlay/offset
    CURSOR
    (- (/ (image-width (text (substring (ts-s ts) 0 (ts-c ts)) TEXT-SIZE TEXT-COLOR)) 2)) 0
    (text (ts-s ts) TEXT-SIZE TEXT-COLOR))
   (/ (image-width (text (ts-s ts) TEXT-SIZE TEXT-COLOR)) 2) 
   CTR-Y
   MTS))


;; TextState KeyEvent -> TextState
;; insert input character to the string displayed on scene 
;; change cursor's x-position to next string insertion postion
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