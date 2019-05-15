clc;
clear all;
close all;
%masukkan pesan rahasia
pesan = fileread('test.txt');
%pesan teks dijadikan angka
pesan = uint8(pesan);
%hitung panjang pesan
panjang_pesan = length(pesan);

%baca citra penampung
citra= imread('D:\Octave\Image\absam.png');
%jika citra penampung RGB maka ubah dulu menjadi grayscale
if size(citra,3)==3
	citra=rgb2gray(citra);
end
%ambil nilai baris dan kolom
[baris, kolom]=size(citra);
%matriks citra dijadikan 1 baris simpan ke dalam stego
stego=citra(:);
%ukir panjang nilai citra pada stego image
panjang_stego=length(stego);

%convert pesan menjadi biner
bit_pesan=[];
for i=1:panjang_pesan
	biner=dec2bin(pesan(i),8);
	bit_pesan = [bit_pesan biner];
end
%ambil nilai panjang bit pesan
panjang_bit_pesan = length(bit_pesan);

ambil_bit_pesan=[];

%proses penyisipan pesan
%nilai awal nilai
n=0;
for i=1:2:panjang_stego
	%hitung nilai d (selisih piksel bertetanggan)
	d=stego(i+1)-stego(i);
	%untuk tabel kuantisasi
	if 0 <= d <= 7; LK=0; n=3;end
	if 8 <= d <= 15; LK=8; n=3;end
	if 16 <= d <= 31; LK=16; n=4;end
	if 32 <= d <= 63; LK=32; n=5;end
	if 64 <= d <= 127; LK=64; n=6;end
	if 128 <= d <= 255; LK=128; n=7;end
	
	if n > length(bit_pesan);
		break
	end
	ambil_bit_pesan=bit_pesan(1:n);
	bit_pesan=bit_pesan(n+1:end);
	%proses menghitung nilai b (pesan)
	b=bin2dec(ambil_bit_pesan);
	if d >= 0; d1 = LK +b; else d1 = -(LK+b); end
	%hitung nilai m
	m = d1-d; bawah=floor(m/2); atas=ceil(m/2);
	%jika m nilainya ganjil
	if mod(m,2)==1, stego(i)=stego(i) - atas;
		stego(i+1)=stego(i+1)+bawah;
	end
	%jika m nilainya genap
	if mod(m,2)==0, stego(i)=stego(i) - bawah;
		stego(i+1)=stego(i+1)+atas;
	end
end
%membentuk stego image berdasarkan proses pada variabel 'stego'
stego=reshape(stego, [baris kolom]);
%tampilkan cover image dan stego image 
%figure(1); imshow(citra), title('Cover Image');
figure(2); imshow(stego), title('Stego Image');
imwrite(stego,'stegopvd.png')
