function [r_pos,v_pos,f_pos,r_neg,v_neg,f_neg] = create_eqn(cg)
warning ('off','all');
ad = ['config_' num2str(cg) '.mat'];
ad = ['configs/' ad];
load(ad)


r_pos = flip(r_pos_1)';
v_pos = [flip(v_pos_1) v_pos_2]';
f_pos = [flip(flip(f_pos_1,2),1);f_pos_2 ];

[row, col] = find(isnan(f_pos));

v_pos(25)=0;
v_pos(26)=[];
f_pos(26,:)=[];

if col==1
    for i=1:length(row)
        for j=1:length(col)
            f_pos(row(i),col(j))= (f_pos(row(i)+1,col(j))+f_pos(row(i)-1,col(j)))/2;
        end
    end 
elseif row==50
    for i=1:length(row)
        for j=1:length(col)
            f_pos(row(i),col(j))= (f_pos(row(i),col(j)+1)+f_pos(row(i),col(j)-1))/2;
        end
    end 
else
    for i=1:length(row)
        for j=1:length(col)
            f_pos(row(i),col(j))= (f_pos(row(i),col(j)+1)+f_pos(row(i),col(j)-1))/2;
        end
    end 
end

r_neg = flip(r_neg_1)';
v_neg = [flip(v_neg_1) v_neg_2]';
f_neg = [flip(flip(f_neg_1,2),1);f_neg_2 ];

[row, col] = find(isnan(f_neg));

v_neg(25)=0;
v_neg(26)=[];
f_neg(26,:)=[];


if col==1
    for i=1:length(row)
        for j=1:length(col)
            f_neg(row(i),col(j))= (f_neg(row(i)+1,col(j))+f_neg(row(i)-1,col(j)))/2;
        end
    end 
elseif row==50
    for i=1:length(row)
        for j=1:length(col)
            f_neg(row(i),col(j))= (f_neg(row(i),col(j)+1)+f_neg(row(i),col(j)-1))/2;
        end
    end 
else
    for i=1:length(row)
        for j=1:length(col)
            f_neg(row(i),col(j))= (f_neg(row(i),col(j)+1)+f_neg(row(i),col(j)-1))/2;
        end
    end 
end

end
