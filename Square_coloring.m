function Square_coloring(PX,color,PY, Bace )
hold on;

xlimit = get(gca, 'XLim');                                                  % �f�t�H���gX�����W�ݒ�
ylimit = get(gca, 'YLim');                                                  % �f�t�H���gX�����W�ݒ�
colordflt = [1.0 1.0 0.9];                                                  % �f�t�H���g�F�F�N���[��
if nargin<4, Bace = ylimit(1); end                                          % �ȉ��C����������Ȃ����ɖ��߂܂��B
if nargin<3, PY = [ylimit(2), ylimit(2)]; end                               % 
if nargin<2, color = colordflt; end                                         % 
if nargin<1, PX = [xlimit(1), xlimit(2)]; end                               % 

Area_handle = area(PX , PY, Bace,'FaceAlpha',0.3);                                          % �h��͈�([X_1 X_2],[y1 y2])
hold off;                                                                   % 
set(Area_handle,'FaceColor', color);                                        % �h��Ԃ��F
set(Area_handle,'LineStyle','none');                                        % �h��Ԃ������ɘg��`���Ȃ�
set(Area_handle,'ShowBaseline','off');                                      % �x�[�X���C���̕s����
set(gca,'layer','top');                                                     % grid��h��Ԃ��̑O�ʂɏo��
set(Area_handle.Annotation.LegendInformation, 'IconDisplayStyle','off');    % legend�ɓ���Ȃ��悤�ɂ���
children_handle = get(gca, 'Children');                                     % Axis�I�u�W�F�N�g�̎q�I�u�W�F�N�g���擾
set(gca, 'Children', circshift(children_handle,[-1 0]));                    % �q�I�u�W�F�N�g�̏��ԕύX

set(gca,'Xlim',xlimit);							    % �\���̒���
set(gca,'Ylim',ylimit);							    %
end