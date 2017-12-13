(require '[clojure.string :as str])

(defn catches [depth range dt]
  (= 0 (mod (+ depth dt) (* 2 (- range 1)))))

(defn severity [scanners]
  (defn folder [acc k v]
    (+ acc (if (catches k v 0) (* k v) 0)))
  (reduce-kv folder 0 scanners))

(defn any-catches [scanners dt]
  (defn folder [acc k v]
    (or acc (catches k v dt)))
  (reduce-kv folder false scanners))

(defn best-delay [scanners]
  (first (drop-while #(any-catches scanners %) (iterate inc 0))))

(defn main []
  (def scanners
    (into {} (map #(into [] (map read-string (str/split % #": ")))
                  (line-seq (java.io.BufferedReader. *in*)))))
  (println (severity scanners))
  (println (best-delay scanners)))

(do (main))
