claude đọc gitlog có lấy đc pull request ID không?
Có thể lấy được, nhưng phụ thuộc vào cách merge PR đó:

Merge commit (GitHub tạo commit gộp mặc định): message dạng Merge pull request #123 from user/branch → git log sẽ hiện rõ số PR (#123).
Squash merge: commit message thường tự động có dạng Fix bug abc (#123) (GitHub tự thêm số PR vào cuối title khi squash-merge qua UI) → vẫn thấy được.
Rebase merge: các commit gốc được gắn lại lên nhánh chính, không có thông tin PR nào trong message trừ khi người tạo PR tự ghi tay → git log sẽ không cho ra PR ID.
Nên cách chắc chắn nhất để lấy PR ID là dùng git log --grep "#" hoặc git log --merges để lọc rồi soi message, nhưng nếu cần chính xác 100% thì nên dùng gh pr list --search <commit-sha> hoặc gh api repos/{owner}/{repo}/commits/{sha}/pulls — API này map thẳng từ commit SHA sang PR, không phụ thuộc kiểu merge.

Bạn đang cần tool này cho việc gì — muốn tôi viết lệnh cụ thể để tra PR ID từ 1 commit/sha không?
