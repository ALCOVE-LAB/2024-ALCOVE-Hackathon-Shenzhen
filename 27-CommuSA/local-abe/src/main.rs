use rabe::schemes::ac17::*;
use rabe::utils::policy::pest::PolicyLanguage;

fn main() {
    // 在主函数中调用你的代码
    run_rabe_example();
}

fn run_rabe_example() {
    let (pk, msk) = setup();
    let plaintext = String::from("our plaintext!").into_bytes();
    let policy = String::from(r#""A" and "B""#);
    let ct: Ac17CpCiphertext =
        cp_encrypt(&pk, &policy, &plaintext, PolicyLanguage::HumanPolicy).unwrap();
    let sk: Ac17CpSecretKey = cp_keygen(&msk, &vec!["A".to_string(), "B".to_string()]).unwrap();
    assert_eq!(cp_decrypt(&sk, &ct).unwrap(), plaintext);
}
