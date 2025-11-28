"""
Assignment 1: Check duplicate items from list A and list B
หาค่าซ้ำระหว่าง list A และ list B แล้วเพิ่มเข้า new list
"""

def find_duplicates(list_a, list_b):
    """
    ค้นหาค่าที่ซ้ำกันระหว่าง 2 lists
    
    Args:
        list_a: List แรก
        list_b: List ที่สอง
    
    Returns:
        List ที่มีค่าซ้ำกัน (เรียงลำดับ)
    """
    # แปลงเป็น set เพื่อหา intersection (ค่าที่ซ้ำกัน)
    duplicates = list(set(list_a) & set(list_b))
    # เรียงลำดับผลลัพธ์
    duplicates.sort()
    return duplicates


if __name__ == "__main__":
    # Test data from assignment
    list_a = [1, 2, 3, 5, 6, 8, 9]
    list_b = [3, 2, 1, 5, 6, 0]
    
    result = find_duplicates(list_a, list_b)
    
    print("List A:", list_a)
    print("List B:", list_b)
    print("Duplicate items:", result)
    print(f"\nFound {len(result)} duplicate items: {result}")
