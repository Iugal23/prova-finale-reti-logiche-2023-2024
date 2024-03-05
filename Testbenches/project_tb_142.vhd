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

constant SCENARIO_LENGTH : integer := 619;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (209,0,0,0,94,0,224,0,200,0,98,0,0,0,117,0,126,0,0,0,171,0,61,0,185,0,241,0,185,0,39,0,27,0,21,0,141,0,6,0,94,0,0,0,243,0,0,0,226,0,68,0,0,0,150,0,239,0,161,0,127,0,0,0,8,0,66,0,174,0,0,0,230,0,114,0,162,0,147,0,144,0,85,0,0,0,113,0,157,0,113,0,156,0,0,0,175,0,248,0,106,0,244,0,0,0,83,0,11,0,157,0,185,0,80,0,81,0,0,0,0,0,215,0,0,0,20,0,252,0,254,0,224,0,67,0,55,0,70,0,98,0,0,0,132,0,150,0,37,0,225,0,166,0,48,0,78,0,161,0,77,0,137,0,127,0,0,0,65,0,243,0,19,0,0,0,151,0,126,0,0,0,0,0,226,0,194,0,57,0,75,0,209,0,151,0,119,0,0,0,181,0,0,0,0,0,239,0,0,0,253,0,76,0,0,0,0,0,155,0,20,0,129,0,247,0,63,0,145,0,118,0,2,0,206,0,0,0,14,0,29,0,116,0,2,0,167,0,115,0,128,0,240,0,245,0,9,0,0,0,77,0,11,0,157,0,178,0,128,0,179,0,146,0,183,0,117,0,244,0,0,0,163,0,215,0,153,0,72,0,210,0,218,0,60,0,0,0,44,0,217,0,247,0,231,0,188,0,214,0,214,0,168,0,151,0,11,0,25,0,31,0,149,0,32,0,21,0,212,0,124,0,193,0,186,0,252,0,82,0,107,0,32,0,0,0,47,0,161,0,0,0,59,0,33,0,120,0,5,0,0,0,247,0,93,0,0,0,201,0,0,0,35,0,133,0,152,0,231,0,118,0,37,0,22,0,0,0,213,0,0,0,0,0,0,0,124,0,163,0,170,0,0,0,201,0,69,0,0,0,157,0,62,0,43,0,24,0,210,0,247,0,215,0,146,0,0,0,0,0,111,0,161,0,0,0,5,0,97,0,92,0,0,0,228,0,0,0,117,0,83,0,163,0,76,0,63,0,198,0,41,0,0,0,133,0,0,0,241,0,0,0,0,0,54,0,19,0,241,0,203,0,71,0,74,0,155,0,180,0,174,0,238,0,44,0,69,0,63,0,240,0,32,0,31,0,0,0,0,0,64,0,0,0,0,0,74,0,11,0,157,0,238,0,98,0,93,0,0,0,188,0,0,0,0,0,0,0,10,0,0,0,77,0,163,0,0,0,72,0,79,0,0,0,25,0,30,0,28,0,0,0,212,0,0,0,183,0,18,0,134,0,45,0,214,0,0,0,48,0,244,0,174,0,163,0,255,0,123,0,117,0,6,0,0,0,33,0,84,0,0,0,203,0,86,0,12,0,0,0,76,0,248,0,90,0,149,0,212,0,245,0,31,0,226,0,0,0,83,0,155,0,147,0,144,0,25,0,31,0,202,0,0,0,0,0,54,0,154,0,177,0,1,0,182,0,155,0,0,0,45,0,135,0,194,0,152,0,248,0,98,0,54,0,1,0,148,0,206,0,76,0,57,0,0,0,242,0,144,0,106,0,137,0,155,0,139,0,0,0,109,0,61,0,192,0,154,0,8,0,59,0,154,0,0,0,74,0,224,0,232,0,186,0,35,0,0,0,33,0,147,0,118,0,51,0,183,0,189,0,209,0,0,0,0,0,65,0,255,0,26,0,236,0,69,0,0,0,90,0,233,0,11,0,1,0,0,0,0,0,156,0,75,0,55,0,60,0,100,0,0,0,198,0,119,0,49,0,122,0,232,0,160,0,196,0,0,0,111,0,151,0,0,0,166,0,152,0,254,0,227,0,146,0,133,0,151,0,204,0,236,0,0,0,19,0,0,0,120,0,0,0,239,0,69,0,0,0,212,0,95,0,16,0,83,0,157,0,0,0,207,0,150,0,147,0,0,0,166,0,8,0,66,0,0,0,191,0,150,0,254,0,3,0,106,0,100,0,123,0,140,0,78,0,223,0,0,0,112,0,45,0,157,0,52,0,154,0,65,0,139,0,0,0,121,0,0,0,0,0,0,0,49,0,0,0,0,0,124,0,0,0,10,0,240,0,92,0,229,0,172,0,216,0,72,0,13,0,241,0,147,0,255,0,116,0,35,0,214,0,253,0,208,0,141,0,8,0,0,0,175,0,88,0,229,0,129,0,122,0,246,0,232,0,196,0,0,0,0,0,163,0,84,0,0,0,253,0,0,0,12,0,0,0,0,0,150,0,0,0,45,0,80,0,14,0,0,0,90,0,217,0,38,0,185,0,0,0,51,0,107,0,0,0,183,0,47,0,0,0,0,0,195,0,81,0,13,0,190,0,245,0,223,0,214,0,145,0,11,0,0,0,123,0,0,0,20,0,220,0,136,0,183,0,211,0,36,0,0,0,93,0,193,0,163,0,183,0,152,0,168,0,193,0,80,0,3,0,126,0,205,0,204,0,0,0,12,0,86,0,101,0,0,0,3,0,0,0,0,0,42,0,93,0,5,0,67,0,202,0,206,0,186,0,89,0,57,0,44,0,7,0,247,0,166,0,153,0,0,0,16,0,4,0,162,0,246,0,215,0,131,0,149,0,187,0,0,0,0,0,67,0,220,0,146,0,174,0,229,0,207,0,185,0,158,0,140,0,133,0,245,0,0,0,12,0,70,0,252,0,198,0,186,0,68,0,107,0,178,0,28,0,0,0,17,0,55,0,56,0,176,0,0,0,203,0,0,0,243,0,3,0,222,0,0,0,112,0,139,0,102,0,115,0,252,0,179,0);
signal scenario_full  : scenario_type := (209,31,209,30,94,31,224,31,200,31,98,31,98,30,117,31,126,31,126,30,171,31,61,31,185,31,241,31,185,31,39,31,27,31,21,31,141,31,6,31,94,31,94,30,243,31,243,30,226,31,68,31,68,30,150,31,239,31,161,31,127,31,127,30,8,31,66,31,174,31,174,30,230,31,114,31,162,31,147,31,144,31,85,31,85,30,113,31,157,31,113,31,156,31,156,30,175,31,248,31,106,31,244,31,244,30,83,31,11,31,157,31,185,31,80,31,81,31,81,30,81,29,215,31,215,30,20,31,252,31,254,31,224,31,67,31,55,31,70,31,98,31,98,30,132,31,150,31,37,31,225,31,166,31,48,31,78,31,161,31,77,31,137,31,127,31,127,30,65,31,243,31,19,31,19,30,151,31,126,31,126,30,126,29,226,31,194,31,57,31,75,31,209,31,151,31,119,31,119,30,181,31,181,30,181,29,239,31,239,30,253,31,76,31,76,30,76,29,155,31,20,31,129,31,247,31,63,31,145,31,118,31,2,31,206,31,206,30,14,31,29,31,116,31,2,31,167,31,115,31,128,31,240,31,245,31,9,31,9,30,77,31,11,31,157,31,178,31,128,31,179,31,146,31,183,31,117,31,244,31,244,30,163,31,215,31,153,31,72,31,210,31,218,31,60,31,60,30,44,31,217,31,247,31,231,31,188,31,214,31,214,31,168,31,151,31,11,31,25,31,31,31,149,31,32,31,21,31,212,31,124,31,193,31,186,31,252,31,82,31,107,31,32,31,32,30,47,31,161,31,161,30,59,31,33,31,120,31,5,31,5,30,247,31,93,31,93,30,201,31,201,30,35,31,133,31,152,31,231,31,118,31,37,31,22,31,22,30,213,31,213,30,213,29,213,28,124,31,163,31,170,31,170,30,201,31,69,31,69,30,157,31,62,31,43,31,24,31,210,31,247,31,215,31,146,31,146,30,146,29,111,31,161,31,161,30,5,31,97,31,92,31,92,30,228,31,228,30,117,31,83,31,163,31,76,31,63,31,198,31,41,31,41,30,133,31,133,30,241,31,241,30,241,29,54,31,19,31,241,31,203,31,71,31,74,31,155,31,180,31,174,31,238,31,44,31,69,31,63,31,240,31,32,31,31,31,31,30,31,29,64,31,64,30,64,29,74,31,11,31,157,31,238,31,98,31,93,31,93,30,188,31,188,30,188,29,188,28,10,31,10,30,77,31,163,31,163,30,72,31,79,31,79,30,25,31,30,31,28,31,28,30,212,31,212,30,183,31,18,31,134,31,45,31,214,31,214,30,48,31,244,31,174,31,163,31,255,31,123,31,117,31,6,31,6,30,33,31,84,31,84,30,203,31,86,31,12,31,12,30,76,31,248,31,90,31,149,31,212,31,245,31,31,31,226,31,226,30,83,31,155,31,147,31,144,31,25,31,31,31,202,31,202,30,202,29,54,31,154,31,177,31,1,31,182,31,155,31,155,30,45,31,135,31,194,31,152,31,248,31,98,31,54,31,1,31,148,31,206,31,76,31,57,31,57,30,242,31,144,31,106,31,137,31,155,31,139,31,139,30,109,31,61,31,192,31,154,31,8,31,59,31,154,31,154,30,74,31,224,31,232,31,186,31,35,31,35,30,33,31,147,31,118,31,51,31,183,31,189,31,209,31,209,30,209,29,65,31,255,31,26,31,236,31,69,31,69,30,90,31,233,31,11,31,1,31,1,30,1,29,156,31,75,31,55,31,60,31,100,31,100,30,198,31,119,31,49,31,122,31,232,31,160,31,196,31,196,30,111,31,151,31,151,30,166,31,152,31,254,31,227,31,146,31,133,31,151,31,204,31,236,31,236,30,19,31,19,30,120,31,120,30,239,31,69,31,69,30,212,31,95,31,16,31,83,31,157,31,157,30,207,31,150,31,147,31,147,30,166,31,8,31,66,31,66,30,191,31,150,31,254,31,3,31,106,31,100,31,123,31,140,31,78,31,223,31,223,30,112,31,45,31,157,31,52,31,154,31,65,31,139,31,139,30,121,31,121,30,121,29,121,28,49,31,49,30,49,29,124,31,124,30,10,31,240,31,92,31,229,31,172,31,216,31,72,31,13,31,241,31,147,31,255,31,116,31,35,31,214,31,253,31,208,31,141,31,8,31,8,30,175,31,88,31,229,31,129,31,122,31,246,31,232,31,196,31,196,30,196,29,163,31,84,31,84,30,253,31,253,30,12,31,12,30,12,29,150,31,150,30,45,31,80,31,14,31,14,30,90,31,217,31,38,31,185,31,185,30,51,31,107,31,107,30,183,31,47,31,47,30,47,29,195,31,81,31,13,31,190,31,245,31,223,31,214,31,145,31,11,31,11,30,123,31,123,30,20,31,220,31,136,31,183,31,211,31,36,31,36,30,93,31,193,31,163,31,183,31,152,31,168,31,193,31,80,31,3,31,126,31,205,31,204,31,204,30,12,31,86,31,101,31,101,30,3,31,3,30,3,29,42,31,93,31,5,31,67,31,202,31,206,31,186,31,89,31,57,31,44,31,7,31,247,31,166,31,153,31,153,30,16,31,4,31,162,31,246,31,215,31,131,31,149,31,187,31,187,30,187,29,67,31,220,31,146,31,174,31,229,31,207,31,185,31,158,31,140,31,133,31,245,31,245,30,12,31,70,31,252,31,198,31,186,31,68,31,107,31,178,31,28,31,28,30,17,31,55,31,56,31,176,31,176,30,203,31,203,30,243,31,3,31,222,31,222,30,112,31,139,31,102,31,115,31,252,31,179,31);

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
