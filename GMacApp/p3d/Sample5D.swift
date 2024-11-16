//
//  Sample5D.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class Sample5D: Sample4D {
    public var type: Int = 0

    /**
     * @param x
     * @param y
     * @param z
     * @param time
     * @param type
     */
    init(_ x: Double, _ y: Double, _ z: Double, _ time: Int64, _ type: Int) {
        super.init(x, y, z, time)
        self.type = type
    }

    /**
     * @param x
     */
    init(_ sample: Sample5D) {
        super.init(sample.x, sample.y, sample.z, sample.time)
        self.type = sample.type
    }

    /**
     * @param x
     * @param y
     * @param z
     * @param time
     * @param type
     */
    public func setFrom(_ x: Double, _ y: Double, _ z: Double, _ time: Int64, _ type: Int) {
        self.x = x
        self.y = y
        self.z = z
        self.time = time
        self.type = type
    }

    /**
     *
     * @return
     */
    public func getType() -> Int {
        return self.type
    }

}
