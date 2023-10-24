function Square_coloring(PX,color,PY, Bace )
hold on;

xlimit = get(gca, 'XLim');                                                  % デフォルトXレンジ設定
ylimit = get(gca, 'YLim');                                                  % デフォルトXレンジ設定
colordflt = [1.0 1.0 0.9];                                                  % デフォルト色：クリーム
if nargin<4, Bace = ylimit(1); end                                          % 以下，引数が足りない時に埋めます。
if nargin<3, PY = [ylimit(2), ylimit(2)]; end                               % 
if nargin<2, color = colordflt; end                                         % 
if nargin<1, PX = [xlimit(1), xlimit(2)]; end                               % 

Area_handle = area(PX , PY, Bace,'FaceAlpha',0.3);                                          % 塗る範囲([X_1 X_2],[y1 y2])
hold off;                                                                   % 
set(Area_handle,'FaceColor', color);                                        % 塗りつぶし色
set(Area_handle,'LineStyle','none');                                        % 塗りつぶし部分に枠を描かない
set(Area_handle,'ShowBaseline','off');                                      % ベースラインの不可視化
set(gca,'layer','top');                                                     % gridを塗りつぶしの前面に出す
set(Area_handle.Annotation.LegendInformation, 'IconDisplayStyle','off');    % legendに入れないようにする
children_handle = get(gca, 'Children');                                     % Axisオブジェクトの子オブジェクトを取得
set(gca, 'Children', circshift(children_handle,[-1 0]));                    % 子オブジェクトの順番変更

set(gca,'Xlim',xlimit);							    % 表示の調整
set(gca,'Ylim',ylimit);							    %
end