import numpy as np
import pandas as pd
import argparse

def preview_npy_file(file_path, num_rows=5):
    data = np.load(file_path, allow_pickle=True)
    
    if isinstance(data, np.ndarray):
        df = pd.DataFrame(data)
        print(df.head(num_rows))
    else:
        print("The loaded .npy file is not a NumPy array and cannot be converted to a DataFrame.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Preview the start of a DataFrame stored in a .npy file.")
    parser.add_argument("file_path", type=str, help="Path to the .npy file")
    parser.add_argument("--num_rows", type=int, default=5, help="Number of rows to preview (default: 5)")
    
    args = parser.parse_args()
    preview_npy_file(args.file_path, args.num_rows)
