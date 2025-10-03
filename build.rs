#![allow(unused)]

fn cmd(prog: &str, args: &[&str]) {
    std::process::Command::new(prog)
        .args(args)
        .status()
        .expect("Command should be run successfully");
}

const VCVARS64: &str = "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Auxiliary\\Build\\vcvars64.bat";

fn main() {
    #[cfg(target_os = "windows")]
    cmd(VCVARS64, &[]);

    static_vcruntime::metabuild();
}
