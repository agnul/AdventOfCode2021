(ns day_03
  (:require [clojure.string :as str]))

(def test-report
  (map #(Long/parseLong % 2)
       '("00100" "11110" "10110" "10111" 
         "10101" "01111" "00111" "11100" 
         "10000" "11001" "00010" "01010")))

(def diagnostic-report
  (->> (slurp "../inputs/day_03.txt")
       (str/split-lines)
       (map #(Long/parseLong % 2))))

(defn select-zeros
  [numbers bit]
  (let [bit-mask (bit-shift-left 1 bit)]
    (filter #(zero? (bit-and % bit-mask)) numbers)))

(defn select-ones
  [numbers bit]
  (let [bit-mask (bit-shift-left 1 bit)]
    (filter #(pos? (bit-and % bit-mask)) numbers)))

(defn count-ones
  [numbers bit]
  (count (select-ones numbers bit)))

(defn select-by-bit-value
  [numbers bit value]
  (cond
    (zero? value) (select-zeros numbers bit)
    (pos? value) (select-ones numbers bit)))

(defn most-frequent-bit
  [numbers bit]
  (let [half (/ (count numbers) 2)]
    (if (>= (count-ones numbers bit) half) 1 0)))

(defn least-frequent-bit
  [numbers bit]
  (let [half (/ (count numbers) 2)]
    (if (< (count-ones numbers bit) half) 1 0)))

(defn bits-to-number
  [bits]
  (reduce (fn [num bit] (+ (* num 2) bit)) 0 bits))

(defn gamma
  [numbers word-size]
  (bits-to-number
   (map (partial most-frequent-bit numbers)
        (range (- word-size 1) -1 -1))))

(defn epsilon
  [numbers word-size]
  (bits-to-number
   (map (partial least-frequent-bit numbers)
        (range (- word-size 1) -1 -1))))

(defn oxigen-rating
  [numbers bit]
  (if (= 1 (count numbers))
    (first numbers)
    (oxigen-rating
     (select-by-bit-value numbers (dec bit) (most-frequent-bit numbers (dec bit)))
     (dec bit))))

(defn co2-rating
  [numbers bit]
  (if (= 1 (count numbers))
    (first numbers)
    (co2-rating
     (select-by-bit-value numbers (dec bit) (least-frequent-bit numbers (dec bit)))
     (dec bit))))

(defn part-1
  [report word-size]
  (* (gamma report word-size) 
     (epsilon report word-size)))

(defn part-2
  [report word-size]
  (* (oxigen-rating report word-size)
     (co2-rating report word-size)))

(part-1 test-report 5)
(part-1 diagnostic-report 12)

(part-2 test-report 5)
(part-2 diagnostic-report 12)
