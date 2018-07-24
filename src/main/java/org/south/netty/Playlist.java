package org.south.netty;

//import entity.Ad;

import java.util.ArrayList;
import java.util.List;

// class Ad{
//     char ad;
//     int freq;
//     void print(){
//         System.out.println(ad + " ");
//     }
//     int getFreq(){
//         return this.freq;
//     }
//     public Ad(char c, int freq){
//         this.ad = c;
//         this.freq = freq;
//     }
// }
// class Ad {
//     private int no;
//     private String adName;
//     private Integer freq;

//     public Ad(int no, String adName, Integer freq) {
//         this.no = no;
//         this.adName = adName;
//         this.freq = freq;
//     }

//     public Ad(Ad ad) {
//         this.no = ad.no;
//         this.adName = ad.adName;
//         this.freq = ad.freq;
//     }

//     public Integer getNo() {
//         return no;
//     }

//     public void setNo(int no) {
//         this.no = no;
//     }

//     public String getAdName() {
//         return adName;
//     }

//     public void setAdName(String adName) {
//         this.adName = adName;
//     }

//     public Integer getFreq() {
//         return freq;
//     }

//     public void setFreq(Integer freq) {
//         this.freq = freq;
//     }

//     @Override
//     public String toString() {
//         return getAdName() + "\t" + getFreq();
//     }

//     @Override
//     public boolean equals(Object obj) {
//         if(obj == null) return false;
//         if(this == obj) return true;
//         if(obj instanceof Ad) {
//             Ad ad = (Ad) obj;
//             if(ad.getAdName().equals(this.adName)) return true;
//         }
//         return false;
//     }

//     @Override
//     public int hashCode() {
//         return adName.hashCode();
//     }
// }


/**
 * Created by free_ion on 2017/6/23.
 */
public class Playlist {
    public static  Ad[] generatePlaylist(Ad[] ads) {
    	int equalsFlag = 0;
    	int numFreq = ads[0].getFreq();
    	for(int i = 1; i < ads.length; i++) {
    		if(ads[i].getFreq() != numFreq) {
    			equalsFlag = 1;
    		}
    	}
    	if(equalsFlag == 0) {
    		return ads;
    	}
    	
        //按频次排序
        ads = insertSort(ads);

        List<Integer> pointer = new ArrayList<Integer>();
        List<Integer> freqs = new ArrayList<Integer>();
        freqs.add(ads[0].getFreq());
        for(int i = 1; i < ads.length; i++) {
            if(ads[i].getFreq() != ads[i-1].getFreq()) {
                pointer.add(i);
                freqs.add(ads[i].getFreq());
            }
        }
        
        //约分频次
        int gcd = arrGcd(freqs);
        for(int i = 0; i < freqs.size(); i++) {
            freqs.set(i, freqs.get(i) / gcd);
        }

        pointer.add(0, 0);
        pointer.add(ads.length);
        List<Integer> adNum = new ArrayList<Integer>();
        for(int i = 0; i < pointer.size() - 1; i++) {
            adNum.add(pointer.get(i + 1) - pointer.get(i));
        }

        //求间隔
        //var inter = [];
        int sum = 0;
        for(int i = 0; i < adNum.size(); i++) {
            sum += adNum.get(i) * freqs.get(i);
        }
        //for(var i = 0; i < adNum.length; i++) {
        //inter.push(Math.round(sum / (adNum[i] * freqs[i])));
        //}
        //console.log(inter);
        //排列播表
        Ad[] arrangedAds = new Ad[sum];
        ArrayList<Ad> tempArr2d[] = new ArrayList[sum];
        for(int i = 0; i < sum; i++) {
            tempArr2d[i] = new ArrayList<Ad>();
        }

        //填充空字符串
        Ad ad = new Ad(0, "", 0, 0);
        for(int i = 0; i < sum; i++) {
            tempArr2d[i].add(ad);
        }

        //填充最多的广告
        int inter;

        //int inter = (int) Math.floor(sum / (adNum.get(0) * freqs.get(0)));
        int l = (int) Math.floor(sum / (adNum.get(0) * freqs.get(0) + 1));
        //var l = Math.round(inter/2) - 1;
        for(int j = 0; j < freqs.get(0); j++) {
            for(int k = pointer.get(0); k < pointer.get(1) && l < tempArr2d.length; k++) {
                //tempArr2d[l][0] = ads[k];
                tempArr2d[l].set(0, new Ad(ads[k]));
                boolean flag = true;
                if(sum % (adNum.get(0) * freqs.get(0) + 1) == 0) {
                    inter = sum / (adNum.get(0) * freqs.get(0) + 1 );
                } else {
                    if(flag) {
                        inter = (int) Math.floor(sum / (adNum.get(0) * freqs.get(0) + 1));
                    } else {
                        inter = (int) Math.ceil(sum / (adNum.get(0) * freqs.get(0) + 1));
                    }
                    flag = !flag;
                }
                l += inter;
            }
        }
        //填充其他广告
        for(int i = 1; i < freqs.size(); i++) {
            //inter = (int) Math.floor(sum / (adNum.get(i) * freqs.get(i)));
            //l = 0;
            l = (int) Math.floor(sum / (adNum.get(i) * freqs.get(i) + 1));
            for(int j = 0; j < freqs.get(i); j++) {

                for(int k = pointer.get(i); k < pointer.get(i+1) && l < tempArr2d.length; k++) {
                    tempArr2d[l].add(new Ad(ads[k]));
                    boolean flag = true;
                    if(sum % (adNum.get(i) * freqs.get(i) + 1) == 0) {
                        inter = sum / (adNum.get(i) * freqs.get(i) + 1 );
                    } else {
                        if(flag) {
                            inter = (int) Math.floor(sum / (adNum.get(i) * freqs.get(i) + 1));
                        } else {
                            inter = (int) Math.ceil(sum / (adNum.get(i) * freqs.get(i) + 1));
                        }
                        flag = !flag;
                    }
                    l += inter;
                }
            }
        }

        for(int i = 0, k = 0; i < tempArr2d.length; i++) {
            for(int j = 0; j < tempArr2d[i].size(); j++) {
                if(!tempArr2d[i].get(j).getAdName().equals("")) {
                    arrangedAds[k] = tempArr2d[i].get(j);
                    k++;
                }
            }
        }

        return arrangedAds;
    }

    public static Ad[] insertSort (Ad[] arr) {
        int len = arr.length;

        if (len <= 1) {
            return arr;
        }

        // 1~n-1趟排序
        for (int i = 1; i < len; i++) {
            Ad tmp = arr[i];
            int j = i;
            for (;j > 0 && arr[j - 1].getFreq() < tmp.getFreq(); j--) {
                arr[j] = arr[j - 1];
            }
            arr[j] = tmp;
        }

        return arr;
    }

    public static int arrGcd(List<Integer> arr) {
        int temp = 0;
        for (int i = 0; i < arr.size(); i++){
            if(i == 0)
                temp = arr.get(0);
            else
                temp = gcd(temp, arr.get(i));
        }
        return temp;
    }

    public static int gcd(int a, int b) {
        if (a == 0) return b;
        return gcd(b % a, a);
    }

    public static void main(String[] args){
        System.out.println("232323232");
        // int k = 0;
        // Ad[] a = new Ad[200];
        // for(int i = 0; i < 60; i++){
        //     a[k].ad = 'A';
        //     k++;
        // }
        // for(int i = 0; i < 40; i++){
        //     a[k].ad = 'B';
        //     k++;
        // }
        // for(int i = 0; i < 20; i++){
        //     a[k].ad = 'C';
        //     k++;
        // }
        // for(int i = 0; i < 80; i++){
        //     a[k].ad = 'D';
        //     k++;
        // }
        // Playlist p = new Playlist();
        // Ad[] b = p.generatePlaylist(a);
        // for(int i = 0; i < 200; i++){
        //     b[i].print();
        // }

        Ad a1 = new Ad(1, "A", 10, 15);
        Ad a2 = new Ad(2, "B", 10, 15);
        Ad a3 = new Ad(3, "C", 10, 15);
        Ad a4 = new Ad(4, "D", 10, 15);
        Ad a5 = new Ad(5, "E", 10, 15);
        Ad[] a = new Ad[5];
        a[0] = a1;
        a[1] = a2;
        a[2] = a3;
        a[3] = a4;
        a[4] = a5;
        Playlist p = new Playlist();
        Ad[] d = p.generatePlaylist(a);
        System.out.println(d.length);
        for(int i = 0; i < d.length; i++){
            System.out.print(d[i].getAdName() + " ");
        }

    }
}