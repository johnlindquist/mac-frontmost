export type FrontmostApp = {
    localizedName: string;
    bundleIdentifier: string;
    bundleURLPath: string;
    executableURLPath: string;
    isFinishedLaunching: boolean;
    processIdentifier: number;
    x: number;
    y: number;
    width: number;
    height: number;
};
export declare const getFrontmostApp: () => FrontmostApp;
