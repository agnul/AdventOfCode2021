(ns day_02
  (:require [clojure.string :as str]))

(defn parse-line
  [line]
  (let [[direction units] (str/split line #" ")]
    [(keyword direction) (Long/parseLong units)]))

(def commands
  (->> (slurp "../inputs/day_02.txt")
       (str/split-lines)
       (map parse-line)))

(defn execute
  [cmd posn depth]
  (let [[direction units] cmd]
    (case direction
      :forward [(+ posn units) depth]
      :down    [posn (+ depth units)]
      :up      [posn (- depth units)])))
 
(defn execute-pt-2
  [cmd aim posn depth]
  (let [[direction units] cmd]
    (case direction
      :forward [aim (+ posn units) (+ (* aim units) depth)]
      :down    [(+ aim units) posn depth]
      :up      [(- aim units) posn depth])))

(defn part-1
  [cmds]
  (let [[posn depth] 
        (reduce (fn [[posn depth] cmd]
                  (execute cmd posn depth))
                [0 0] cmds)]
    (* posn depth)))

(defn part-2
  [cmds]
  (let [[_ posn depth] 
        (reduce (fn [[aim posn depth] cmd]
                  (execute-pt-2 cmd aim posn depth))
                [0 0 0] cmds)]
    (* posn depth)))

(part-1 commands)
(part-2 commands)