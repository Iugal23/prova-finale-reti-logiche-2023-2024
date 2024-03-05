-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 567;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (186,0,23,0,91,0,0,0,70,0,90,0,111,0,186,0,118,0,68,0,198,0,43,0,239,0,115,0,224,0,0,0,0,0,25,0,226,0,0,0,0,0,140,0,201,0,146,0,128,0,0,0,0,0,233,0,148,0,110,0,0,0,0,0,222,0,0,0,13,0,70,0,0,0,0,0,0,0,76,0,0,0,0,0,84,0,0,0,143,0,0,0,110,0,0,0,78,0,202,0,81,0,4,0,91,0,0,0,48,0,110,0,132,0,66,0,209,0,106,0,105,0,253,0,0,0,173,0,221,0,37,0,7,0,253,0,118,0,154,0,196,0,232,0,0,0,237,0,42,0,112,0,171,0,193,0,111,0,0,0,176,0,210,0,68,0,226,0,16,0,103,0,117,0,189,0,0,0,0,0,34,0,0,0,0,0,170,0,138,0,191,0,112,0,0,0,0,0,212,0,0,0,0,0,115,0,0,0,185,0,155,0,83,0,95,0,0,0,31,0,84,0,0,0,80,0,42,0,0,0,71,0,86,0,23,0,195,0,77,0,220,0,50,0,28,0,0,0,122,0,15,0,45,0,175,0,250,0,0,0,60,0,88,0,84,0,49,0,71,0,2,0,81,0,0,0,0,0,0,0,128,0,51,0,20,0,146,0,104,0,196,0,140,0,159,0,0,0,0,0,4,0,94,0,178,0,7,0,192,0,239,0,61,0,208,0,0,0,178,0,173,0,140,0,95,0,164,0,64,0,152,0,12,0,22,0,165,0,230,0,197,0,0,0,22,0,65,0,86,0,1,0,156,0,0,0,253,0,220,0,195,0,125,0,0,0,0,0,127,0,113,0,18,0,183,0,90,0,69,0,214,0,48,0,131,0,248,0,0,0,217,0,140,0,1,0,43,0,0,0,47,0,101,0,107,0,180,0,0,0,47,0,129,0,228,0,176,0,96,0,0,0,84,0,255,0,115,0,117,0,223,0,220,0,247,0,90,0,70,0,148,0,120,0,16,0,122,0,107,0,95,0,218,0,159,0,20,0,35,0,69,0,0,0,43,0,61,0,92,0,52,0,0,0,241,0,22,0,216,0,54,0,0,0,0,0,163,0,230,0,29,0,0,0,0,0,208,0,0,0,60,0,162,0,32,0,57,0,71,0,230,0,0,0,118,0,231,0,9,0,0,0,179,0,3,0,23,0,23,0,40,0,126,0,0,0,0,0,0,0,214,0,0,0,4,0,0,0,11,0,128,0,0,0,147,0,124,0,0,0,125,0,244,0,15,0,2,0,149,0,246,0,244,0,217,0,41,0,0,0,91,0,0,0,222,0,204,0,0,0,0,0,43,0,9,0,0,0,115,0,64,0,183,0,101,0,50,0,59,0,0,0,71,0,187,0,0,0,0,0,223,0,170,0,148,0,66,0,149,0,217,0,13,0,0,0,0,0,85,0,242,0,94,0,48,0,203,0,162,0,210,0,0,0,78,0,177,0,0,0,62,0,0,0,233,0,16,0,0,0,0,0,98,0,106,0,187,0,105,0,160,0,0,0,90,0,59,0,126,0,77,0,3,0,0,0,103,0,10,0,86,0,221,0,87,0,180,0,104,0,10,0,230,0,28,0,195,0,232,0,134,0,189,0,147,0,16,0,0,0,4,0,135,0,63,0,69,0,86,0,0,0,106,0,52,0,0,0,58,0,223,0,186,0,42,0,85,0,185,0,204,0,183,0,238,0,62,0,128,0,123,0,20,0,117,0,2,0,0,0,151,0,70,0,98,0,182,0,61,0,0,0,23,0,154,0,163,0,77,0,117,0,222,0,128,0,243,0,187,0,0,0,147,0,158,0,243,0,0,0,164,0,226,0,106,0,63,0,0,0,50,0,83,0,0,0,224,0,195,0,40,0,126,0,218,0,229,0,227,0,209,0,145,0,15,0,221,0,0,0,185,0,109,0,37,0,0,0,36,0,7,0,54,0,152,0,181,0,198,0,241,0,184,0,194,0,251,0,218,0,146,0,0,0,170,0,29,0,231,0,0,0,0,0,178,0,113,0,0,0,201,0,161,0,157,0,215,0,117,0,210,0,0,0,27,0,125,0,165,0,0,0,180,0,75,0,132,0,27,0,0,0,236,0,42,0,0,0,176,0,56,0,230,0,135,0,0,0,15,0,146,0,16,0,127,0,12,0,72,0,99,0,0,0,41,0,66,0,32,0,208,0,0,0,247,0,76,0,101,0,0,0,13,0,5,0,189,0,141,0,7,0,0,0,0,0,0,0,170,0,153,0,79,0,177,0,125,0,141,0,161,0,233,0,118,0,0,0,0,0,237,0,244,0,60,0,0,0,95,0,170,0,161,0,101,0,231,0,187,0,118,0,207,0,167,0,0,0,174,0,0,0,153,0,4,0,38,0,222,0,65,0,167,0,89,0,0,0,50,0,0,0,64,0,51,0,145,0,43,0,102,0,148,0,215,0,75,0,173,0,205,0,153,0,164,0,9,0,0,0,0,0,189,0,72,0,101,0,147,0,0,0,120,0,0,0,173,0,41,0,185,0,151,0);
signal scenario_full  : scenario_type := (186,31,23,31,91,31,91,30,70,31,90,31,111,31,186,31,118,31,68,31,198,31,43,31,239,31,115,31,224,31,224,30,224,29,25,31,226,31,226,30,226,29,140,31,201,31,146,31,128,31,128,30,128,29,233,31,148,31,110,31,110,30,110,29,222,31,222,30,13,31,70,31,70,30,70,29,70,28,76,31,76,30,76,29,84,31,84,30,143,31,143,30,110,31,110,30,78,31,202,31,81,31,4,31,91,31,91,30,48,31,110,31,132,31,66,31,209,31,106,31,105,31,253,31,253,30,173,31,221,31,37,31,7,31,253,31,118,31,154,31,196,31,232,31,232,30,237,31,42,31,112,31,171,31,193,31,111,31,111,30,176,31,210,31,68,31,226,31,16,31,103,31,117,31,189,31,189,30,189,29,34,31,34,30,34,29,170,31,138,31,191,31,112,31,112,30,112,29,212,31,212,30,212,29,115,31,115,30,185,31,155,31,83,31,95,31,95,30,31,31,84,31,84,30,80,31,42,31,42,30,71,31,86,31,23,31,195,31,77,31,220,31,50,31,28,31,28,30,122,31,15,31,45,31,175,31,250,31,250,30,60,31,88,31,84,31,49,31,71,31,2,31,81,31,81,30,81,29,81,28,128,31,51,31,20,31,146,31,104,31,196,31,140,31,159,31,159,30,159,29,4,31,94,31,178,31,7,31,192,31,239,31,61,31,208,31,208,30,178,31,173,31,140,31,95,31,164,31,64,31,152,31,12,31,22,31,165,31,230,31,197,31,197,30,22,31,65,31,86,31,1,31,156,31,156,30,253,31,220,31,195,31,125,31,125,30,125,29,127,31,113,31,18,31,183,31,90,31,69,31,214,31,48,31,131,31,248,31,248,30,217,31,140,31,1,31,43,31,43,30,47,31,101,31,107,31,180,31,180,30,47,31,129,31,228,31,176,31,96,31,96,30,84,31,255,31,115,31,117,31,223,31,220,31,247,31,90,31,70,31,148,31,120,31,16,31,122,31,107,31,95,31,218,31,159,31,20,31,35,31,69,31,69,30,43,31,61,31,92,31,52,31,52,30,241,31,22,31,216,31,54,31,54,30,54,29,163,31,230,31,29,31,29,30,29,29,208,31,208,30,60,31,162,31,32,31,57,31,71,31,230,31,230,30,118,31,231,31,9,31,9,30,179,31,3,31,23,31,23,31,40,31,126,31,126,30,126,29,126,28,214,31,214,30,4,31,4,30,11,31,128,31,128,30,147,31,124,31,124,30,125,31,244,31,15,31,2,31,149,31,246,31,244,31,217,31,41,31,41,30,91,31,91,30,222,31,204,31,204,30,204,29,43,31,9,31,9,30,115,31,64,31,183,31,101,31,50,31,59,31,59,30,71,31,187,31,187,30,187,29,223,31,170,31,148,31,66,31,149,31,217,31,13,31,13,30,13,29,85,31,242,31,94,31,48,31,203,31,162,31,210,31,210,30,78,31,177,31,177,30,62,31,62,30,233,31,16,31,16,30,16,29,98,31,106,31,187,31,105,31,160,31,160,30,90,31,59,31,126,31,77,31,3,31,3,30,103,31,10,31,86,31,221,31,87,31,180,31,104,31,10,31,230,31,28,31,195,31,232,31,134,31,189,31,147,31,16,31,16,30,4,31,135,31,63,31,69,31,86,31,86,30,106,31,52,31,52,30,58,31,223,31,186,31,42,31,85,31,185,31,204,31,183,31,238,31,62,31,128,31,123,31,20,31,117,31,2,31,2,30,151,31,70,31,98,31,182,31,61,31,61,30,23,31,154,31,163,31,77,31,117,31,222,31,128,31,243,31,187,31,187,30,147,31,158,31,243,31,243,30,164,31,226,31,106,31,63,31,63,30,50,31,83,31,83,30,224,31,195,31,40,31,126,31,218,31,229,31,227,31,209,31,145,31,15,31,221,31,221,30,185,31,109,31,37,31,37,30,36,31,7,31,54,31,152,31,181,31,198,31,241,31,184,31,194,31,251,31,218,31,146,31,146,30,170,31,29,31,231,31,231,30,231,29,178,31,113,31,113,30,201,31,161,31,157,31,215,31,117,31,210,31,210,30,27,31,125,31,165,31,165,30,180,31,75,31,132,31,27,31,27,30,236,31,42,31,42,30,176,31,56,31,230,31,135,31,135,30,15,31,146,31,16,31,127,31,12,31,72,31,99,31,99,30,41,31,66,31,32,31,208,31,208,30,247,31,76,31,101,31,101,30,13,31,5,31,189,31,141,31,7,31,7,30,7,29,7,28,170,31,153,31,79,31,177,31,125,31,141,31,161,31,233,31,118,31,118,30,118,29,237,31,244,31,60,31,60,30,95,31,170,31,161,31,101,31,231,31,187,31,118,31,207,31,167,31,167,30,174,31,174,30,153,31,4,31,38,31,222,31,65,31,167,31,89,31,89,30,50,31,50,30,64,31,51,31,145,31,43,31,102,31,148,31,215,31,75,31,173,31,205,31,153,31,164,31,9,31,9,30,9,29,189,31,72,31,101,31,147,31,147,30,120,31,120,30,173,31,41,31,185,31,151,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
