-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_79 is
end project_tb_79;

architecture project_tb_arch_79 of project_tb_79 is
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

constant SCENARIO_LENGTH : integer := 524;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (103,0,197,0,82,0,0,0,194,0,64,0,0,0,102,0,99,0,8,0,90,0,69,0,15,0,31,0,245,0,130,0,13,0,0,0,228,0,0,0,74,0,221,0,225,0,0,0,0,0,0,0,91,0,61,0,0,0,162,0,0,0,94,0,144,0,0,0,189,0,30,0,47,0,42,0,63,0,9,0,50,0,3,0,86,0,85,0,170,0,235,0,211,0,254,0,164,0,251,0,0,0,7,0,58,0,128,0,98,0,58,0,123,0,161,0,63,0,0,0,0,0,0,0,17,0,123,0,0,0,157,0,248,0,154,0,0,0,91,0,136,0,164,0,103,0,118,0,0,0,112,0,21,0,199,0,213,0,0,0,0,0,36,0,47,0,66,0,0,0,175,0,0,0,109,0,4,0,136,0,146,0,248,0,16,0,124,0,71,0,156,0,0,0,0,0,110,0,187,0,31,0,174,0,19,0,143,0,179,0,253,0,0,0,0,0,0,0,167,0,74,0,6,0,149,0,0,0,191,0,219,0,160,0,0,0,233,0,0,0,21,0,0,0,200,0,0,0,0,0,162,0,114,0,230,0,146,0,0,0,115,0,133,0,53,0,0,0,167,0,58,0,0,0,195,0,156,0,229,0,251,0,208,0,0,0,213,0,220,0,0,0,0,0,0,0,142,0,22,0,100,0,138,0,167,0,58,0,1,0,53,0,179,0,0,0,228,0,47,0,0,0,213,0,0,0,200,0,72,0,0,0,34,0,233,0,0,0,66,0,5,0,102,0,0,0,62,0,244,0,122,0,0,0,0,0,30,0,73,0,197,0,245,0,106,0,0,0,100,0,220,0,153,0,0,0,216,0,0,0,19,0,37,0,0,0,125,0,0,0,204,0,83,0,0,0,0,0,153,0,0,0,0,0,29,0,0,0,0,0,28,0,159,0,179,0,62,0,15,0,70,0,228,0,0,0,159,0,40,0,123,0,95,0,0,0,123,0,79,0,188,0,178,0,0,0,0,0,114,0,82,0,227,0,163,0,33,0,238,0,0,0,56,0,194,0,40,0,36,0,0,0,236,0,223,0,26,0,127,0,237,0,112,0,163,0,44,0,203,0,0,0,59,0,0,0,79,0,104,0,96,0,218,0,135,0,88,0,65,0,62,0,0,0,199,0,194,0,71,0,195,0,127,0,80,0,1,0,174,0,122,0,131,0,152,0,62,0,178,0,34,0,182,0,84,0,232,0,236,0,0,0,9,0,91,0,215,0,168,0,239,0,223,0,0,0,130,0,158,0,113,0,55,0,0,0,110,0,82,0,196,0,232,0,0,0,0,0,84,0,200,0,161,0,175,0,90,0,97,0,50,0,114,0,199,0,0,0,254,0,0,0,229,0,196,0,212,0,67,0,165,0,217,0,87,0,133,0,0,0,117,0,10,0,0,0,224,0,252,0,52,0,0,0,35,0,28,0,176,0,156,0,146,0,0,0,231,0,233,0,0,0,237,0,136,0,198,0,153,0,241,0,166,0,57,0,0,0,251,0,0,0,193,0,86,0,219,0,40,0,0,0,10,0,244,0,0,0,204,0,137,0,164,0,246,0,0,0,0,0,243,0,0,0,230,0,112,0,162,0,66,0,126,0,88,0,131,0,97,0,81,0,249,0,0,0,0,0,219,0,242,0,85,0,120,0,51,0,0,0,210,0,157,0,0,0,207,0,3,0,176,0,172,0,254,0,65,0,237,0,117,0,0,0,24,0,197,0,166,0,132,0,141,0,11,0,161,0,74,0,102,0,46,0,135,0,234,0,6,0,241,0,109,0,194,0,252,0,199,0,151,0,182,0,60,0,93,0,103,0,0,0,217,0,104,0,0,0,150,0,131,0,178,0,140,0,31,0,42,0,162,0,1,0,95,0,0,0,200,0,149,0,180,0,138,0,73,0,110,0,0,0,34,0,0,0,160,0,130,0,71,0,201,0,185,0,11,0,82,0,137,0,34,0,243,0,0,0,28,0,179,0,39,0,250,0,142,0,15,0,237,0,236,0,128,0,0,0,243,0,98,0,219,0,169,0,222,0,0,0,11,0,55,0,0,0,26,0,27,0,0,0,145,0,211,0,242,0,173,0,129,0,214,0,104,0,246,0,40,0,198,0,195,0,218,0,0,0,228,0,0,0,17,0,37,0,226,0,11,0,173,0,13,0,211,0,165,0,83,0,0,0,126,0,33,0,225,0,0,0,91,0,74,0,39,0,129,0,24,0,151,0,253,0,163,0,153,0,0,0,136,0,185,0,0,0,0,0,209,0,17,0,0,0,63,0,38,0,50,0,126,0,234,0,45,0,90,0,38,0,0,0,228,0,243,0,8,0);
signal scenario_full  : scenario_type := (103,31,197,31,82,31,82,30,194,31,64,31,64,30,102,31,99,31,8,31,90,31,69,31,15,31,31,31,245,31,130,31,13,31,13,30,228,31,228,30,74,31,221,31,225,31,225,30,225,29,225,28,91,31,61,31,61,30,162,31,162,30,94,31,144,31,144,30,189,31,30,31,47,31,42,31,63,31,9,31,50,31,3,31,86,31,85,31,170,31,235,31,211,31,254,31,164,31,251,31,251,30,7,31,58,31,128,31,98,31,58,31,123,31,161,31,63,31,63,30,63,29,63,28,17,31,123,31,123,30,157,31,248,31,154,31,154,30,91,31,136,31,164,31,103,31,118,31,118,30,112,31,21,31,199,31,213,31,213,30,213,29,36,31,47,31,66,31,66,30,175,31,175,30,109,31,4,31,136,31,146,31,248,31,16,31,124,31,71,31,156,31,156,30,156,29,110,31,187,31,31,31,174,31,19,31,143,31,179,31,253,31,253,30,253,29,253,28,167,31,74,31,6,31,149,31,149,30,191,31,219,31,160,31,160,30,233,31,233,30,21,31,21,30,200,31,200,30,200,29,162,31,114,31,230,31,146,31,146,30,115,31,133,31,53,31,53,30,167,31,58,31,58,30,195,31,156,31,229,31,251,31,208,31,208,30,213,31,220,31,220,30,220,29,220,28,142,31,22,31,100,31,138,31,167,31,58,31,1,31,53,31,179,31,179,30,228,31,47,31,47,30,213,31,213,30,200,31,72,31,72,30,34,31,233,31,233,30,66,31,5,31,102,31,102,30,62,31,244,31,122,31,122,30,122,29,30,31,73,31,197,31,245,31,106,31,106,30,100,31,220,31,153,31,153,30,216,31,216,30,19,31,37,31,37,30,125,31,125,30,204,31,83,31,83,30,83,29,153,31,153,30,153,29,29,31,29,30,29,29,28,31,159,31,179,31,62,31,15,31,70,31,228,31,228,30,159,31,40,31,123,31,95,31,95,30,123,31,79,31,188,31,178,31,178,30,178,29,114,31,82,31,227,31,163,31,33,31,238,31,238,30,56,31,194,31,40,31,36,31,36,30,236,31,223,31,26,31,127,31,237,31,112,31,163,31,44,31,203,31,203,30,59,31,59,30,79,31,104,31,96,31,218,31,135,31,88,31,65,31,62,31,62,30,199,31,194,31,71,31,195,31,127,31,80,31,1,31,174,31,122,31,131,31,152,31,62,31,178,31,34,31,182,31,84,31,232,31,236,31,236,30,9,31,91,31,215,31,168,31,239,31,223,31,223,30,130,31,158,31,113,31,55,31,55,30,110,31,82,31,196,31,232,31,232,30,232,29,84,31,200,31,161,31,175,31,90,31,97,31,50,31,114,31,199,31,199,30,254,31,254,30,229,31,196,31,212,31,67,31,165,31,217,31,87,31,133,31,133,30,117,31,10,31,10,30,224,31,252,31,52,31,52,30,35,31,28,31,176,31,156,31,146,31,146,30,231,31,233,31,233,30,237,31,136,31,198,31,153,31,241,31,166,31,57,31,57,30,251,31,251,30,193,31,86,31,219,31,40,31,40,30,10,31,244,31,244,30,204,31,137,31,164,31,246,31,246,30,246,29,243,31,243,30,230,31,112,31,162,31,66,31,126,31,88,31,131,31,97,31,81,31,249,31,249,30,249,29,219,31,242,31,85,31,120,31,51,31,51,30,210,31,157,31,157,30,207,31,3,31,176,31,172,31,254,31,65,31,237,31,117,31,117,30,24,31,197,31,166,31,132,31,141,31,11,31,161,31,74,31,102,31,46,31,135,31,234,31,6,31,241,31,109,31,194,31,252,31,199,31,151,31,182,31,60,31,93,31,103,31,103,30,217,31,104,31,104,30,150,31,131,31,178,31,140,31,31,31,42,31,162,31,1,31,95,31,95,30,200,31,149,31,180,31,138,31,73,31,110,31,110,30,34,31,34,30,160,31,130,31,71,31,201,31,185,31,11,31,82,31,137,31,34,31,243,31,243,30,28,31,179,31,39,31,250,31,142,31,15,31,237,31,236,31,128,31,128,30,243,31,98,31,219,31,169,31,222,31,222,30,11,31,55,31,55,30,26,31,27,31,27,30,145,31,211,31,242,31,173,31,129,31,214,31,104,31,246,31,40,31,198,31,195,31,218,31,218,30,228,31,228,30,17,31,37,31,226,31,11,31,173,31,13,31,211,31,165,31,83,31,83,30,126,31,33,31,225,31,225,30,91,31,74,31,39,31,129,31,24,31,151,31,253,31,163,31,153,31,153,30,136,31,185,31,185,30,185,29,209,31,17,31,17,30,63,31,38,31,50,31,126,31,234,31,45,31,90,31,38,31,38,30,228,31,243,31,8,31);

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
