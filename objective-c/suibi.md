### 自定义cell
+ 重写tableViewCell后，利用tag来调用自己在cell上新添加的控件，其中myCell是继承自UITableViewCell的自定义子类，并重写了initWithStyle方法
```
//遵守UITableViewDelegate协议的*.m文件
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
 
    if(!cell)
    {
        cell=[[myCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"MyIdentifier"];
    }
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [NSString stringWithFormat:@"%d", indexPath.row];
 
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [NSString stringWithFormat:@"%d", NUMBER_OF_ROWS - indexPath.row];
 
    return cell;
}
```
