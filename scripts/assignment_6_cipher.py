"""
Assignment 6: Caesar Cipher Decoder
เขียนฟังก์ชัน Python ถอดรหัส Caesar Cipher

Caesar Cipher คือการเข้ารหัสโดยเลื่อนตัวอักษรไป k ตำแหน่ง
การถอดรหัสจะเลื่อนกลับมา k ตำแหน่ง (counter-clockwise)
"""

def simple_cipher(encrypted, k):
    """
    ถอดรหัส Caesar Cipher
    
    Args:
        encrypted (str): ข้อความที่ถูกเข้ารหัส (ตัวพิมพ์ใหญ่เท่านั้น A-Z)
        k (int): จำนวนตำแหน่งที่ถูกเลื่อน
    
    Returns:
        str: ข้อความที่ถอดรหัสแล้ว
    
    Example:
        >>> simple_cipher('VTAOG', 2)
        'TRYME'
    """
    decrypted = ""
    
    for char in encrypted:
        if char.isalpha() and char.isupper():
            # แปลง char เป็นตำแหน่ง (A=0, B=1, ..., Z=25)
            position = ord(char) - ord('A')
            
            # เลื่อนกลับ k ตำแหน่ง (counter-clockwise)
            # ใช้ modulo 26 เพื่อให้วนกลับไปต้นวงกลมเมื่อเกิน
            new_position = (position - k) % 26
            
            # แปลงกลับเป็นตัวอักษร
            decrypted_char = chr(new_position + ord('A'))
            decrypted += decrypted_char
        else:
            # ถ้าไม่ใช่ตัวอักษรพิมพ์ใหญ่ ให้คงไว้เหมือนเดิม
            decrypted += char
    
    return decrypted


def encrypt_cipher(text, k):
    """
    เข้ารหัสด้วย Caesar Cipher (สำหรับทดสอบ)
    
    Args:
        text (str): ข้อความที่ต้องการเข้ารหัส
        k (int): จำนวนตำแหน่งที่ต้องการเลื่อน
    
    Returns:
        str: ข้อความที่เข้ารหัสแล้ว
    """
    encrypted = ""
    
    for char in text:
        if char.isalpha() and char.isupper():
            position = ord(char) - ord('A')
            new_position = (position + k) % 26
            encrypted_char = chr(new_position + ord('A'))
            encrypted += encrypted_char
        else:
            encrypted += char
    
    return encrypted


if __name__ == "__main__":
    # Test case from assignment
    print("=== Caesar Cipher Decoder ===\n")
    
    # Example from assignment
    encrypted_text = "VTAOG"
    k = 2
    decrypted_text = simple_cipher(encrypted_text, k)
    
    print(f"Encrypted: {encrypted_text}")
    print(f"k = {k}")
    print(f"Decrypted: {decrypted_text}")
    print()
    
    # เคสที่อธิบายวิธีทำ
    print("=== Step by step explanation ===")
    print(f"Looking back {k} from 'V' returns 'T'")
    print(f"Looking back {k} from 'T' returns 'R'")
    print(f"Looking back {k} from 'A' returns 'Y' (wraps around)")
    print(f"Looking back {k} from 'O' returns 'M'")
    print(f"Looking back {k} from 'G' returns 'E'")
    print(f"\nResult: TRYME")
    print()
    
    # Additional test cases
    print("=== Additional Test Cases ===")
    test_cases = [
        ("HELLO", 3),
        ("WORLD", 5),
        ("PYTHON", 7),
        ("ABC", 1),
        ("XYZ", 3)
    ]
    
    for original, shift in test_cases:
        encrypted = encrypt_cipher(original, shift)
        decrypted = simple_cipher(encrypted, shift)
        print(f"Original: {original:10} -> Encrypted (k={shift}): {encrypted:10} -> Decrypted: {decrypted}")
