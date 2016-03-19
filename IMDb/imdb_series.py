from pandas import DataFrame,Series
import pandas as pd
import matplotlib.pyplot as plt

############ Define Functions ############

### 1. Create Series data
def create_series_data():
    
    ### Title data
    title = pd.read_csv("title.csv", delimiter=";")
    title = title.drop(["phonetic_code","episode_of_id","season_nr","episode_nr","md5sum"], axis=1)
    #title = title[title["production_year"] >= 1970]
    title = title[title["kind_id"] == 1]
    prd_years= title[["id","production_year","title"]]
    
    ### Series data
    movie_link = pd.read_csv("movie_link.csv", delimiter=";") 
    movie_link = movie_link[movie_link["link_type_id"] == 1]  # 1;"follows"
    
    # Get production years of linked movies
    movie_link = pd.merge(movie_link, prd_years,
                left_on=['linked_movie_id'],
                right_on=['id'],
                how='inner')
    
    movie_link = movie_link.sort(["movie_id", 'production_year',"title"], ascending=[1,1,1])
    movie_link_d = movie_link.drop_duplicates(['movie_id'], take_last=False)
    movie_link_d = movie_link_d[["movie_id","linked_movie_id"]]
    
    ### Merge series data (Series2~)
    series2 = pd.merge(title, movie_link_d,
                left_on=['id'],
                right_on=['movie_id'],
                how='inner')
    
    series2 = series2.sort(["linked_movie_id", 'production_year'], ascending=[1,1])
            
    ### Merge series data (Series1)
    movie_link_d = movie_link_d.drop_duplicates(['linked_movie_id'], take_last=False)
    movie_link_d = movie_link_d.drop(["movie_id"], axis=1)
    
    series1 = pd.merge(title, movie_link_d,
                left_on=['id'],
                right_on=['linked_movie_id'],
                how='inner')
    
    series1["linked_movie_id"] = series1["id"]
    
    ### Convine series data 
    series = pd.concat([series1,series2])
    series = series.sort(["linked_movie_id", 'production_year',"title"], ascending=[1,1,1])
    series = series.reset_index()

    ### Define series number
    series["series_num"] = 0
    id_tmp = 0
    series_num = 0
    count = 0
    for i in range(0,len(series.index)):
        if series["linked_movie_id"][i] != id_tmp:
            count = 1
        else: 
            count += 1
        series["series_num"][i] = count
        id_tmp = series["linked_movie_id"][i]
           
    series_r = series[series["production_year"] >= 1970]
    series_r["series_num"][series_r["series_num"] > 10] = 10
    return series_r

### 2. Create ratings data
def read_ratings():
    movie_info_idx = pd.read_csv("movie_info_idx.csv", delimiter=",") 
    ratings = movie_info_idx[movie_info_idx["info_type_id"] == 101]
    ratings["ratings"] = ratings["info"].astype(float)
    ratings = ratings.drop(["id","info_type_id","note","info"],axis=1)
    ratings["flag_r"] = 1
    return ratings

### 3. Create BoxOffice data
# Define function: Choose only USA
def find_usa(x):
    return x.find("(USA)")

# Define function: Grasp only box office digits
def cnv_degit(x):
    y = x[:x.find('(USA)')]
    return int(filter(str.isdigit, y))

def read_boxoffice():
    movie_info_new = pd.read_csv("movie_info_new.csv", delimiter=";") 
    box_off = movie_info_new[movie_info_new["info_type_id"] == 107]  # Choose box office 
    box_off = box_off[box_off["info"].map(find_usa) > 0]   # Choose only USA
    box_off = box_off.drop(["id","info_type_id","note"],axis=1)
    box_off["box_office"] = box_off["info"].map(cnv_degit) /1000000 # Grasp only box office digits
    
    box_off_max = box_off.groupby(['movie_id'])["box_office"].max().reset_index()
    box_off_max["flag_b"] = 1
    return box_off_max

### 4. Output
def output():
    fig = plt.figure()
    ax1 = fig.add_subplot(2,2,1)
    ax2 = fig.add_subplot(2,2,2) 
    ax3 = fig.add_subplot(2,2,3) 
    ax4 = fig.add_subplot(2,2,4) 
    
    ## Average ratings by series_num
    series_max = series_r[series_r["production_year"] > 2004].groupby(["linked_movie_id"])["series_num"].max().reset_index()
    
    def get_series(series_data, series_max_data, var, max_series):
        series_maxx = series_max_data[series_max_data["series_num"] == max_series]
        series_maxx = series_maxx.drop(["series_num"], axis=1)
        series_rr = pd.merge(series_data, series_maxx,
                    left_on=['linked_movie_id'],
                    right_on=['linked_movie_id'],
                    how='inner')
        series_r_mean = series_rr.groupby(["series_num"])[var].mean()
        return series_r_mean
    
    series_r_mean2 = get_series(series_data=series_r, series_max_data=series_max, var="ratings", max_series=2)
    series_r_mean3 = get_series(series_data=series_r, series_max_data=series_max, var="ratings", max_series=3)
    series_r_mean4 = get_series(series_data=series_r, series_max_data=series_max, var="ratings", max_series=4)
    
    series_r_mean = DataFrame({"2 Series":series_r_mean2, "3 Series":series_r_mean3, "4 Series":series_r_mean4})

    plt.ylabel('Average ratings')
    ax1 = series_r_mean.plot(kind="bar",color=("steelblue","firebrick","goldenrod"), width = 0.8)

    #series_r_cnt = series_rr.groupby(["series_num"])["ratings"].count()
    #plt.title('Number of movies by series')
    #plt.ylabel('Number of movies')
    #ax2 = series_r_cnt.plot(kind="bar", color="green")
    
    plt.show()
    
    ## Average box office by series_num
    series_box_mean2 = get_series(series_data=series_r, series_max_data=series_max, var="box_office", max_series=2)
    series_box_mean3 = get_series(series_data=series_r, series_max_data=series_max, var="box_office", max_series=3)
    series_box_mean4 = get_series(series_data=series_r, series_max_data=series_max, var="box_office", max_series=4)
    #series_box_cnt = series_r.groupby(["series_num"])["box_office"].count()
    
    series_box_mean = DataFrame({"2 Series":series_box_mean2, "3 Series":series_box_mean3, "4 Series":series_box_mean4})
    
    #plt.title('Average box office of movies by series')
    plt.ylabel('Average box office')
    ax3 = series_box_mean.plot(kind="bar",color=("steelblue","firebrick","goldenrod"), width = 0.8)

    #plt.title('Number of movies by series')
    #plt.ylabel('Number of movies')
    #ax4 = series_box_cnt.plot(kind="bar", color="green")
    
    plt.show()


############ Main program ############
series_r    = create_series_data()
ratings     = read_ratings()
box_off_max = read_boxoffice()

series_r = pd.merge(series_r, ratings,
            left_on=['id'],
            right_on=['movie_id'],
            how='left')

series_r = pd.merge(series_r, box_off_max,
            left_on=['id'],
            right_on=['movie_id'],
            how='left')
                
output()

#aa = series_r[["id","linked_movie_id","title","series_num",""]]
series_r.to_csv("series_data.csv")