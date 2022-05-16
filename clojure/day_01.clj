(ns day_01
  (:require [clojure.string :as str]))

(def depths
  (->> (slurp "../inputs/day_01.txt")
       (str/split-lines)
       (mapv #(Long/parseLong %))))

(defn part-1
  [ds]
  (->> (map - (drop 1 ds) ds)
       (filter pos?)
       count))

(defn part-2
  [ds]
  (->> (map - (drop 3 ds) ds)
       (filter pos?)
       count))

(part-1 depths)
(part-2 depths)