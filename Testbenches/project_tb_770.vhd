-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_770 is
end project_tb_770;

architecture project_tb_arch_770 of project_tb_770 is
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

constant SCENARIO_LENGTH : integer := 608;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (3,0,181,0,149,0,0,0,88,0,0,0,0,0,96,0,140,0,233,0,173,0,182,0,0,0,153,0,153,0,0,0,0,0,0,0,0,0,185,0,0,0,198,0,92,0,226,0,176,0,38,0,86,0,201,0,177,0,244,0,226,0,171,0,0,0,192,0,0,0,164,0,104,0,44,0,185,0,111,0,70,0,112,0,90,0,117,0,138,0,171,0,0,0,0,0,46,0,0,0,91,0,83,0,0,0,0,0,250,0,37,0,0,0,13,0,29,0,255,0,102,0,27,0,63,0,169,0,31,0,110,0,0,0,0,0,0,0,165,0,188,0,110,0,110,0,209,0,115,0,227,0,191,0,86,0,0,0,41,0,225,0,175,0,181,0,0,0,154,0,17,0,135,0,208,0,113,0,211,0,142,0,3,0,39,0,205,0,0,0,177,0,203,0,251,0,58,0,81,0,175,0,90,0,0,0,236,0,149,0,64,0,60,0,229,0,116,0,111,0,221,0,111,0,67,0,92,0,251,0,47,0,0,0,172,0,38,0,58,0,0,0,0,0,228,0,160,0,0,0,80,0,202,0,81,0,150,0,162,0,255,0,143,0,97,0,129,0,134,0,0,0,241,0,68,0,51,0,0,0,197,0,55,0,226,0,0,0,90,0,220,0,0,0,211,0,0,0,194,0,168,0,1,0,231,0,123,0,41,0,220,0,82,0,19,0,204,0,0,0,200,0,185,0,119,0,0,0,203,0,30,0,65,0,0,0,179,0,0,0,74,0,106,0,25,0,132,0,110,0,67,0,0,0,207,0,221,0,141,0,51,0,212,0,200,0,61,0,95,0,231,0,215,0,66,0,7,0,58,0,0,0,24,0,220,0,101,0,0,0,7,0,49,0,119,0,0,0,0,0,253,0,247,0,233,0,156,0,139,0,11,0,175,0,55,0,180,0,169,0,234,0,0,0,0,0,0,0,0,0,31,0,0,0,45,0,0,0,46,0,156,0,219,0,0,0,0,0,234,0,221,0,48,0,164,0,0,0,201,0,90,0,145,0,206,0,158,0,96,0,66,0,114,0,13,0,48,0,243,0,154,0,62,0,141,0,216,0,185,0,167,0,124,0,87,0,166,0,0,0,160,0,173,0,12,0,225,0,73,0,229,0,133,0,143,0,184,0,245,0,0,0,0,0,0,0,0,0,212,0,0,0,13,0,177,0,35,0,249,0,82,0,137,0,225,0,0,0,27,0,95,0,255,0,44,0,0,0,0,0,72,0,0,0,101,0,165,0,168,0,110,0,147,0,12,0,34,0,153,0,252,0,82,0,41,0,177,0,46,0,0,0,5,0,0,0,114,0,200,0,0,0,58,0,61,0,50,0,219,0,0,0,244,0,0,0,34,0,37,0,21,0,63,0,58,0,101,0,0,0,0,0,93,0,59,0,214,0,224,0,195,0,117,0,107,0,0,0,102,0,48,0,10,0,235,0,13,0,115,0,0,0,120,0,0,0,245,0,207,0,0,0,220,0,0,0,195,0,100,0,205,0,0,0,13,0,132,0,0,0,148,0,69,0,0,0,33,0,141,0,0,0,0,0,180,0,242,0,251,0,81,0,189,0,0,0,181,0,222,0,218,0,0,0,73,0,0,0,0,0,242,0,14,0,200,0,0,0,220,0,142,0,151,0,175,0,0,0,153,0,192,0,17,0,78,0,185,0,0,0,240,0,216,0,91,0,0,0,45,0,0,0,137,0,144,0,89,0,219,0,246,0,118,0,100,0,187,0,200,0,0,0,113,0,229,0,82,0,0,0,241,0,0,0,89,0,0,0,0,0,200,0,58,0,89,0,188,0,0,0,64,0,27,0,144,0,187,0,209,0,87,0,214,0,30,0,240,0,240,0,8,0,0,0,64,0,31,0,0,0,33,0,0,0,212,0,23,0,140,0,215,0,111,0,72,0,119,0,0,0,9,0,199,0,85,0,49,0,191,0,0,0,143,0,0,0,0,0,150,0,0,0,231,0,156,0,192,0,0,0,168,0,176,0,212,0,84,0,118,0,45,0,239,0,0,0,41,0,11,0,36,0,38,0,106,0,159,0,187,0,0,0,179,0,250,0,87,0,9,0,173,0,28,0,37,0,43,0,49,0,67,0,53,0,1,0,53,0,31,0,10,0,242,0,239,0,118,0,50,0,250,0,122,0,19,0,0,0,57,0,30,0,0,0,70,0,235,0,94,0,99,0,197,0,23,0,0,0,103,0,130,0,0,0,0,0,164,0,1,0,237,0,67,0,135,0,125,0,124,0,49,0,43,0,0,0,0,0,0,0,0,0,215,0,37,0,154,0,244,0,229,0,190,0,0,0,22,0,6,0,75,0,43,0,198,0,60,0,101,0,151,0,144,0,179,0,223,0,142,0,0,0,72,0,152,0,27,0,0,0,7,0,211,0,195,0,77,0,144,0,7,0,142,0,0,0,80,0,0,0,230,0,0,0,67,0,234,0,214,0,29,0,0,0,181,0,28,0,162,0,57,0,226,0,80,0,142,0,205,0,0,0,25,0,17,0,40,0,0,0,0,0,229,0,124,0,26,0,0,0,127,0,0,0,0,0,0,0,193,0,214,0,105,0,44,0,129,0,0,0,238,0,0,0,168,0,28,0,86,0,0,0,112,0,85,0,114,0,178,0,5,0,173,0,36,0,247,0,244,0,178,0,100,0,52,0,91,0,184,0,13,0,25,0,164,0);
signal scenario_full  : scenario_type := (3,31,181,31,149,31,149,30,88,31,88,30,88,29,96,31,140,31,233,31,173,31,182,31,182,30,153,31,153,31,153,30,153,29,153,28,153,27,185,31,185,30,198,31,92,31,226,31,176,31,38,31,86,31,201,31,177,31,244,31,226,31,171,31,171,30,192,31,192,30,164,31,104,31,44,31,185,31,111,31,70,31,112,31,90,31,117,31,138,31,171,31,171,30,171,29,46,31,46,30,91,31,83,31,83,30,83,29,250,31,37,31,37,30,13,31,29,31,255,31,102,31,27,31,63,31,169,31,31,31,110,31,110,30,110,29,110,28,165,31,188,31,110,31,110,31,209,31,115,31,227,31,191,31,86,31,86,30,41,31,225,31,175,31,181,31,181,30,154,31,17,31,135,31,208,31,113,31,211,31,142,31,3,31,39,31,205,31,205,30,177,31,203,31,251,31,58,31,81,31,175,31,90,31,90,30,236,31,149,31,64,31,60,31,229,31,116,31,111,31,221,31,111,31,67,31,92,31,251,31,47,31,47,30,172,31,38,31,58,31,58,30,58,29,228,31,160,31,160,30,80,31,202,31,81,31,150,31,162,31,255,31,143,31,97,31,129,31,134,31,134,30,241,31,68,31,51,31,51,30,197,31,55,31,226,31,226,30,90,31,220,31,220,30,211,31,211,30,194,31,168,31,1,31,231,31,123,31,41,31,220,31,82,31,19,31,204,31,204,30,200,31,185,31,119,31,119,30,203,31,30,31,65,31,65,30,179,31,179,30,74,31,106,31,25,31,132,31,110,31,67,31,67,30,207,31,221,31,141,31,51,31,212,31,200,31,61,31,95,31,231,31,215,31,66,31,7,31,58,31,58,30,24,31,220,31,101,31,101,30,7,31,49,31,119,31,119,30,119,29,253,31,247,31,233,31,156,31,139,31,11,31,175,31,55,31,180,31,169,31,234,31,234,30,234,29,234,28,234,27,31,31,31,30,45,31,45,30,46,31,156,31,219,31,219,30,219,29,234,31,221,31,48,31,164,31,164,30,201,31,90,31,145,31,206,31,158,31,96,31,66,31,114,31,13,31,48,31,243,31,154,31,62,31,141,31,216,31,185,31,167,31,124,31,87,31,166,31,166,30,160,31,173,31,12,31,225,31,73,31,229,31,133,31,143,31,184,31,245,31,245,30,245,29,245,28,245,27,212,31,212,30,13,31,177,31,35,31,249,31,82,31,137,31,225,31,225,30,27,31,95,31,255,31,44,31,44,30,44,29,72,31,72,30,101,31,165,31,168,31,110,31,147,31,12,31,34,31,153,31,252,31,82,31,41,31,177,31,46,31,46,30,5,31,5,30,114,31,200,31,200,30,58,31,61,31,50,31,219,31,219,30,244,31,244,30,34,31,37,31,21,31,63,31,58,31,101,31,101,30,101,29,93,31,59,31,214,31,224,31,195,31,117,31,107,31,107,30,102,31,48,31,10,31,235,31,13,31,115,31,115,30,120,31,120,30,245,31,207,31,207,30,220,31,220,30,195,31,100,31,205,31,205,30,13,31,132,31,132,30,148,31,69,31,69,30,33,31,141,31,141,30,141,29,180,31,242,31,251,31,81,31,189,31,189,30,181,31,222,31,218,31,218,30,73,31,73,30,73,29,242,31,14,31,200,31,200,30,220,31,142,31,151,31,175,31,175,30,153,31,192,31,17,31,78,31,185,31,185,30,240,31,216,31,91,31,91,30,45,31,45,30,137,31,144,31,89,31,219,31,246,31,118,31,100,31,187,31,200,31,200,30,113,31,229,31,82,31,82,30,241,31,241,30,89,31,89,30,89,29,200,31,58,31,89,31,188,31,188,30,64,31,27,31,144,31,187,31,209,31,87,31,214,31,30,31,240,31,240,31,8,31,8,30,64,31,31,31,31,30,33,31,33,30,212,31,23,31,140,31,215,31,111,31,72,31,119,31,119,30,9,31,199,31,85,31,49,31,191,31,191,30,143,31,143,30,143,29,150,31,150,30,231,31,156,31,192,31,192,30,168,31,176,31,212,31,84,31,118,31,45,31,239,31,239,30,41,31,11,31,36,31,38,31,106,31,159,31,187,31,187,30,179,31,250,31,87,31,9,31,173,31,28,31,37,31,43,31,49,31,67,31,53,31,1,31,53,31,31,31,10,31,242,31,239,31,118,31,50,31,250,31,122,31,19,31,19,30,57,31,30,31,30,30,70,31,235,31,94,31,99,31,197,31,23,31,23,30,103,31,130,31,130,30,130,29,164,31,1,31,237,31,67,31,135,31,125,31,124,31,49,31,43,31,43,30,43,29,43,28,43,27,215,31,37,31,154,31,244,31,229,31,190,31,190,30,22,31,6,31,75,31,43,31,198,31,60,31,101,31,151,31,144,31,179,31,223,31,142,31,142,30,72,31,152,31,27,31,27,30,7,31,211,31,195,31,77,31,144,31,7,31,142,31,142,30,80,31,80,30,230,31,230,30,67,31,234,31,214,31,29,31,29,30,181,31,28,31,162,31,57,31,226,31,80,31,142,31,205,31,205,30,25,31,17,31,40,31,40,30,40,29,229,31,124,31,26,31,26,30,127,31,127,30,127,29,127,28,193,31,214,31,105,31,44,31,129,31,129,30,238,31,238,30,168,31,28,31,86,31,86,30,112,31,85,31,114,31,178,31,5,31,173,31,36,31,247,31,244,31,178,31,100,31,52,31,91,31,184,31,13,31,25,31,164,31);

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
