import os
import requests
import time
import random  # 导入 random 模块

openai_api_key = "在这里填入您的OpenAI API密钥" # 设置 OpenAI API 密钥

def generate_response(prompt):
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {openai_api_key}"
    }

    data = {
        "model": "gpt-3.5-turbo",
        "messages": [
            {"role": "system", "content": ""},  # 自定义 content
            {"role": "user", "content": prompt}
        ]
    }

    response = requests.post("在这里填入OpenAI API的URL", headers=headers, json=data)  # 替换为正确的OpenAI API URL
    response_data = response.json()
    print(f"状态码: {response.status_code}")
    print(f"响应内容: {response_data}")
    return response_data['choices'][0]['message']['content']

def process_text(input_text, prompt):
    response = generate_response(input_text + prompt)
    return response

def is_empty_or_whitespace(text):
    return not text.strip()

def process_files_in_directory(input_directory, output_directory, prompt):
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)
    processed_files = set(os.listdir(output_directory))
    for filename in os.listdir(input_directory):
        if filename.endswith(".txt") and f"output_{filename}" not in processed_files:
            input_file_path = os.path.join(input_directory, filename)
            output_file_path = os.path.join(output_directory, f"output_{filename}")

            with open(input_file_path, 'r', encoding='utf-8') as input_file:
                input_text = input_file.read()

            if is_empty_or_whitespace(input_text):
                print(f"文件 {filename} 中只包含空行或空格，跳过处理该文件。")
                continue
            try:
                response = process_text(input_text, prompt)
            except Exception as e:
                print(f"处理文件 {filename} 时出现错误：{str(e)}，跳过处理该文件。")
                continue

            with open(output_file_path, 'w', encoding='utf-8') as output_file:
                output_file.write(response)
            print(f"已处理文件: {filename}")
            wait_time = random.randint(1, 10)
            time.sleep(wait_time)

def main():
    input_directory = r"在这里填入实际的输入目录路径"
    output_directory = "在这里填入实际的输出目录路径"
    prompt = "在这里填入您想要的自定义 prompt"
    process_files_in_directory(input_directory, output_directory, prompt)
    print("所有文件处理完成并已写入输出目录。")

if __name__ == "__main__":
    main()