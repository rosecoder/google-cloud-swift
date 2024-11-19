extension Task where Success == Never, Failure == Never {

    public static func sleepUntilCancelled() async throws {
        while !isCancelled {
            try await sleep(nanoseconds: .max / 2)
        }
    }
}
