-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_796 is
end project_tb_796;

architecture project_tb_arch_796 of project_tb_796 is
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

constant SCENARIO_LENGTH : integer := 599;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (36,0,138,0,0,0,0,0,203,0,120,0,178,0,71,0,126,0,226,0,23,0,0,0,11,0,41,0,0,0,0,0,17,0,145,0,220,0,0,0,202,0,0,0,128,0,0,0,0,0,244,0,35,0,8,0,84,0,238,0,0,0,164,0,0,0,195,0,0,0,0,0,47,0,49,0,125,0,250,0,100,0,37,0,128,0,61,0,0,0,180,0,149,0,0,0,12,0,185,0,0,0,205,0,0,0,174,0,210,0,100,0,0,0,149,0,16,0,174,0,95,0,1,0,50,0,8,0,0,0,189,0,46,0,214,0,144,0,62,0,18,0,188,0,0,0,68,0,60,0,144,0,50,0,217,0,216,0,120,0,142,0,0,0,191,0,0,0,27,0,48,0,98,0,168,0,112,0,49,0,172,0,161,0,97,0,0,0,105,0,120,0,67,0,135,0,235,0,92,0,252,0,188,0,0,0,198,0,29,0,230,0,153,0,0,0,60,0,125,0,36,0,49,0,0,0,9,0,0,0,0,0,0,0,139,0,0,0,248,0,241,0,62,0,0,0,168,0,3,0,3,0,211,0,0,0,202,0,59,0,170,0,153,0,235,0,10,0,90,0,194,0,131,0,204,0,29,0,173,0,31,0,0,0,99,0,65,0,162,0,24,0,131,0,125,0,0,0,0,0,0,0,159,0,0,0,251,0,103,0,170,0,71,0,64,0,60,0,165,0,142,0,249,0,0,0,0,0,36,0,0,0,210,0,0,0,0,0,147,0,0,0,0,0,0,0,18,0,17,0,195,0,0,0,0,0,168,0,32,0,110,0,0,0,219,0,58,0,0,0,149,0,109,0,240,0,37,0,198,0,30,0,230,0,82,0,108,0,79,0,26,0,218,0,0,0,121,0,37,0,171,0,0,0,15,0,208,0,197,0,85,0,10,0,3,0,220,0,0,0,105,0,155,0,107,0,0,0,211,0,203,0,8,0,158,0,0,0,0,0,45,0,230,0,33,0,193,0,49,0,202,0,85,0,154,0,0,0,0,0,229,0,231,0,135,0,98,0,230,0,238,0,146,0,24,0,96,0,227,0,73,0,241,0,0,0,0,0,42,0,200,0,113,0,0,0,53,0,179,0,131,0,165,0,0,0,242,0,0,0,84,0,145,0,200,0,78,0,219,0,169,0,227,0,45,0,0,0,99,0,0,0,78,0,38,0,239,0,33,0,165,0,0,0,202,0,230,0,0,0,155,0,67,0,0,0,253,0,198,0,115,0,46,0,63,0,197,0,216,0,233,0,21,0,76,0,51,0,43,0,9,0,223,0,195,0,205,0,0,0,14,0,21,0,195,0,57,0,3,0,151,0,24,0,74,0,100,0,121,0,33,0,3,0,102,0,77,0,72,0,0,0,0,0,212,0,89,0,53,0,87,0,17,0,80,0,68,0,62,0,199,0,240,0,0,0,242,0,116,0,0,0,215,0,191,0,200,0,86,0,0,0,189,0,214,0,101,0,26,0,231,0,0,0,125,0,230,0,120,0,196,0,57,0,230,0,240,0,0,0,0,0,110,0,7,0,0,0,114,0,226,0,126,0,79,0,0,0,199,0,252,0,0,0,14,0,0,0,7,0,224,0,62,0,0,0,170,0,118,0,55,0,173,0,41,0,0,0,0,0,0,0,213,0,188,0,138,0,216,0,187,0,8,0,21,0,249,0,1,0,208,0,70,0,169,0,0,0,27,0,73,0,18,0,0,0,73,0,246,0,99,0,69,0,12,0,225,0,106,0,84,0,155,0,144,0,127,0,135,0,13,0,64,0,85,0,63,0,178,0,23,0,253,0,37,0,59,0,5,0,252,0,255,0,0,0,44,0,26,0,83,0,6,0,153,0,0,0,123,0,183,0,0,0,0,0,56,0,154,0,117,0,43,0,44,0,206,0,0,0,0,0,34,0,164,0,42,0,30,0,0,0,28,0,43,0,229,0,7,0,55,0,149,0,0,0,89,0,68,0,0,0,88,0,100,0,0,0,0,0,0,0,0,0,13,0,73,0,229,0,135,0,0,0,160,0,0,0,146,0,0,0,239,0,173,0,59,0,33,0,153,0,0,0,111,0,116,0,51,0,200,0,0,0,167,0,68,0,154,0,0,0,0,0,207,0,23,0,0,0,0,0,185,0,36,0,86,0,155,0,150,0,197,0,127,0,0,0,0,0,41,0,221,0,18,0,90,0,108,0,223,0,127,0,51,0,86,0,179,0,0,0,0,0,232,0,84,0,174,0,153,0,0,0,165,0,107,0,202,0,0,0,7,0,181,0,0,0,112,0,162,0,229,0,0,0,6,0,164,0,217,0,129,0,203,0,13,0,111,0,49,0,159,0,148,0,36,0,37,0,9,0,20,0,92,0,0,0,226,0,245,0,159,0,32,0,11,0,102,0,101,0,93,0,0,0,0,0,0,0,54,0,243,0,54,0,29,0,31,0,69,0,81,0,215,0,230,0,0,0,199,0,91,0,192,0,101,0,0,0,0,0,54,0,88,0,141,0,161,0,188,0,253,0,44,0,193,0,232,0,44,0,6,0,37,0,28,0,213,0,0,0,215,0,72,0,101,0,248,0,5,0,253,0,208,0,84,0,0,0,34,0,131,0,149,0,0,0,0,0,119,0,212,0,0,0,114,0,65,0,186,0,0,0,187,0,0,0);
signal scenario_full  : scenario_type := (36,31,138,31,138,30,138,29,203,31,120,31,178,31,71,31,126,31,226,31,23,31,23,30,11,31,41,31,41,30,41,29,17,31,145,31,220,31,220,30,202,31,202,30,128,31,128,30,128,29,244,31,35,31,8,31,84,31,238,31,238,30,164,31,164,30,195,31,195,30,195,29,47,31,49,31,125,31,250,31,100,31,37,31,128,31,61,31,61,30,180,31,149,31,149,30,12,31,185,31,185,30,205,31,205,30,174,31,210,31,100,31,100,30,149,31,16,31,174,31,95,31,1,31,50,31,8,31,8,30,189,31,46,31,214,31,144,31,62,31,18,31,188,31,188,30,68,31,60,31,144,31,50,31,217,31,216,31,120,31,142,31,142,30,191,31,191,30,27,31,48,31,98,31,168,31,112,31,49,31,172,31,161,31,97,31,97,30,105,31,120,31,67,31,135,31,235,31,92,31,252,31,188,31,188,30,198,31,29,31,230,31,153,31,153,30,60,31,125,31,36,31,49,31,49,30,9,31,9,30,9,29,9,28,139,31,139,30,248,31,241,31,62,31,62,30,168,31,3,31,3,31,211,31,211,30,202,31,59,31,170,31,153,31,235,31,10,31,90,31,194,31,131,31,204,31,29,31,173,31,31,31,31,30,99,31,65,31,162,31,24,31,131,31,125,31,125,30,125,29,125,28,159,31,159,30,251,31,103,31,170,31,71,31,64,31,60,31,165,31,142,31,249,31,249,30,249,29,36,31,36,30,210,31,210,30,210,29,147,31,147,30,147,29,147,28,18,31,17,31,195,31,195,30,195,29,168,31,32,31,110,31,110,30,219,31,58,31,58,30,149,31,109,31,240,31,37,31,198,31,30,31,230,31,82,31,108,31,79,31,26,31,218,31,218,30,121,31,37,31,171,31,171,30,15,31,208,31,197,31,85,31,10,31,3,31,220,31,220,30,105,31,155,31,107,31,107,30,211,31,203,31,8,31,158,31,158,30,158,29,45,31,230,31,33,31,193,31,49,31,202,31,85,31,154,31,154,30,154,29,229,31,231,31,135,31,98,31,230,31,238,31,146,31,24,31,96,31,227,31,73,31,241,31,241,30,241,29,42,31,200,31,113,31,113,30,53,31,179,31,131,31,165,31,165,30,242,31,242,30,84,31,145,31,200,31,78,31,219,31,169,31,227,31,45,31,45,30,99,31,99,30,78,31,38,31,239,31,33,31,165,31,165,30,202,31,230,31,230,30,155,31,67,31,67,30,253,31,198,31,115,31,46,31,63,31,197,31,216,31,233,31,21,31,76,31,51,31,43,31,9,31,223,31,195,31,205,31,205,30,14,31,21,31,195,31,57,31,3,31,151,31,24,31,74,31,100,31,121,31,33,31,3,31,102,31,77,31,72,31,72,30,72,29,212,31,89,31,53,31,87,31,17,31,80,31,68,31,62,31,199,31,240,31,240,30,242,31,116,31,116,30,215,31,191,31,200,31,86,31,86,30,189,31,214,31,101,31,26,31,231,31,231,30,125,31,230,31,120,31,196,31,57,31,230,31,240,31,240,30,240,29,110,31,7,31,7,30,114,31,226,31,126,31,79,31,79,30,199,31,252,31,252,30,14,31,14,30,7,31,224,31,62,31,62,30,170,31,118,31,55,31,173,31,41,31,41,30,41,29,41,28,213,31,188,31,138,31,216,31,187,31,8,31,21,31,249,31,1,31,208,31,70,31,169,31,169,30,27,31,73,31,18,31,18,30,73,31,246,31,99,31,69,31,12,31,225,31,106,31,84,31,155,31,144,31,127,31,135,31,13,31,64,31,85,31,63,31,178,31,23,31,253,31,37,31,59,31,5,31,252,31,255,31,255,30,44,31,26,31,83,31,6,31,153,31,153,30,123,31,183,31,183,30,183,29,56,31,154,31,117,31,43,31,44,31,206,31,206,30,206,29,34,31,164,31,42,31,30,31,30,30,28,31,43,31,229,31,7,31,55,31,149,31,149,30,89,31,68,31,68,30,88,31,100,31,100,30,100,29,100,28,100,27,13,31,73,31,229,31,135,31,135,30,160,31,160,30,146,31,146,30,239,31,173,31,59,31,33,31,153,31,153,30,111,31,116,31,51,31,200,31,200,30,167,31,68,31,154,31,154,30,154,29,207,31,23,31,23,30,23,29,185,31,36,31,86,31,155,31,150,31,197,31,127,31,127,30,127,29,41,31,221,31,18,31,90,31,108,31,223,31,127,31,51,31,86,31,179,31,179,30,179,29,232,31,84,31,174,31,153,31,153,30,165,31,107,31,202,31,202,30,7,31,181,31,181,30,112,31,162,31,229,31,229,30,6,31,164,31,217,31,129,31,203,31,13,31,111,31,49,31,159,31,148,31,36,31,37,31,9,31,20,31,92,31,92,30,226,31,245,31,159,31,32,31,11,31,102,31,101,31,93,31,93,30,93,29,93,28,54,31,243,31,54,31,29,31,31,31,69,31,81,31,215,31,230,31,230,30,199,31,91,31,192,31,101,31,101,30,101,29,54,31,88,31,141,31,161,31,188,31,253,31,44,31,193,31,232,31,44,31,6,31,37,31,28,31,213,31,213,30,215,31,72,31,101,31,248,31,5,31,253,31,208,31,84,31,84,30,34,31,131,31,149,31,149,30,149,29,119,31,212,31,212,30,114,31,65,31,186,31,186,30,187,31,187,30);

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
