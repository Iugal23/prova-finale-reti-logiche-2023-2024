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

constant SCENARIO_LENGTH : integer := 621;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (12,0,0,0,20,0,17,0,105,0,169,0,108,0,113,0,130,0,225,0,0,0,94,0,195,0,137,0,82,0,235,0,0,0,151,0,248,0,0,0,194,0,246,0,158,0,0,0,50,0,231,0,218,0,12,0,236,0,122,0,11,0,248,0,174,0,230,0,100,0,0,0,249,0,99,0,242,0,188,0,242,0,169,0,26,0,57,0,18,0,250,0,63,0,0,0,194,0,76,0,206,0,127,0,228,0,118,0,169,0,0,0,193,0,0,0,35,0,235,0,55,0,108,0,0,0,250,0,237,0,0,0,251,0,130,0,203,0,0,0,87,0,254,0,0,0,242,0,220,0,56,0,0,0,4,0,112,0,48,0,222,0,0,0,11,0,224,0,73,0,0,0,54,0,113,0,140,0,0,0,0,0,0,0,222,0,97,0,189,0,144,0,189,0,0,0,4,0,154,0,177,0,198,0,67,0,212,0,95,0,25,0,5,0,113,0,20,0,49,0,213,0,213,0,94,0,220,0,129,0,185,0,226,0,255,0,152,0,156,0,178,0,185,0,35,0,25,0,113,0,113,0,106,0,118,0,0,0,138,0,143,0,163,0,0,0,73,0,80,0,0,0,226,0,51,0,253,0,162,0,225,0,119,0,47,0,30,0,0,0,40,0,116,0,190,0,243,0,0,0,37,0,227,0,58,0,192,0,81,0,247,0,0,0,121,0,170,0,181,0,0,0,0,0,0,0,165,0,20,0,0,0,82,0,223,0,141,0,41,0,0,0,107,0,149,0,171,0,8,0,0,0,0,0,8,0,119,0,47,0,231,0,117,0,179,0,82,0,0,0,0,0,164,0,0,0,28,0,190,0,0,0,1,0,153,0,0,0,214,0,0,0,248,0,201,0,113,0,37,0,74,0,0,0,110,0,0,0,20,0,0,0,98,0,160,0,190,0,0,0,0,0,128,0,0,0,189,0,90,0,31,0,29,0,210,0,147,0,71,0,0,0,211,0,239,0,0,0,78,0,8,0,87,0,0,0,58,0,17,0,0,0,128,0,66,0,2,0,199,0,0,0,71,0,159,0,100,0,227,0,79,0,76,0,0,0,125,0,0,0,206,0,177,0,62,0,178,0,175,0,2,0,0,0,177,0,112,0,0,0,135,0,168,0,252,0,0,0,0,0,149,0,190,0,208,0,158,0,139,0,47,0,163,0,237,0,4,0,238,0,46,0,30,0,0,0,36,0,128,0,106,0,146,0,3,0,103,0,236,0,0,0,230,0,0,0,231,0,212,0,0,0,106,0,144,0,204,0,218,0,117,0,58,0,0,0,178,0,188,0,235,0,202,0,48,0,76,0,122,0,160,0,152,0,204,0,225,0,124,0,191,0,82,0,232,0,164,0,4,0,201,0,66,0,140,0,198,0,73,0,156,0,5,0,0,0,129,0,0,0,0,0,0,0,48,0,180,0,161,0,117,0,103,0,177,0,0,0,0,0,74,0,254,0,143,0,0,0,0,0,166,0,49,0,95,0,199,0,163,0,0,0,46,0,120,0,221,0,122,0,94,0,0,0,208,0,0,0,60,0,184,0,36,0,54,0,200,0,0,0,0,0,222,0,0,0,0,0,84,0,70,0,241,0,121,0,153,0,187,0,0,0,0,0,143,0,96,0,0,0,43,0,50,0,27,0,184,0,102,0,115,0,193,0,55,0,90,0,148,0,245,0,106,0,0,0,11,0,0,0,60,0,142,0,3,0,79,0,32,0,0,0,77,0,197,0,235,0,140,0,95,0,200,0,63,0,0,0,0,0,122,0,175,0,218,0,188,0,73,0,191,0,176,0,0,0,96,0,232,0,0,0,190,0,0,0,204,0,220,0,52,0,200,0,73,0,39,0,202,0,187,0,228,0,26,0,53,0,0,0,217,0,28,0,154,0,0,0,155,0,100,0,224,0,158,0,22,0,200,0,0,0,180,0,0,0,24,0,146,0,106,0,92,0,141,0,125,0,200,0,184,0,237,0,0,0,139,0,99,0,63,0,0,0,167,0,201,0,245,0,226,0,150,0,207,0,0,0,179,0,129,0,0,0,214,0,151,0,0,0,13,0,120,0,0,0,0,0,0,0,48,0,75,0,211,0,2,0,218,0,11,0,1,0,200,0,224,0,0,0,0,0,92,0,0,0,73,0,96,0,180,0,0,0,63,0,80,0,99,0,0,0,0,0,0,0,71,0,118,0,0,0,171,0,198,0,10,0,216,0,212,0,79,0,135,0,78,0,202,0,93,0,0,0,147,0,232,0,103,0,0,0,0,0,78,0,189,0,186,0,17,0,252,0,88,0,125,0,35,0,13,0,113,0,130,0,0,0,192,0,0,0,4,0,234,0,45,0,163,0,0,0,70,0,0,0,164,0,237,0,0,0,16,0,0,0,182,0,145,0,0,0,0,0,232,0,17,0,0,0,146,0,213,0,0,0,0,0,0,0,227,0,0,0,167,0,244,0,237,0,0,0,102,0,0,0,41,0,228,0,156,0,0,0,111,0,138,0,29,0,238,0,210,0,123,0,0,0,214,0,141,0,25,0,5,0,0,0,236,0,0,0,134,0,191,0,0,0,47,0,172,0,211,0,0,0,255,0,49,0,243,0,46,0,0,0,31,0,69,0,78,0,216,0,180,0,0,0,247,0,242,0,150,0,0,0,195,0,0,0,0,0,49,0,0,0,196,0,46,0,202,0,96,0,66,0,196,0,118,0,247,0,53,0,0,0,44,0,67,0,196,0,117,0,234,0,62,0,0,0,0,0);
signal scenario_full  : scenario_type := (12,31,12,30,20,31,17,31,105,31,169,31,108,31,113,31,130,31,225,31,225,30,94,31,195,31,137,31,82,31,235,31,235,30,151,31,248,31,248,30,194,31,246,31,158,31,158,30,50,31,231,31,218,31,12,31,236,31,122,31,11,31,248,31,174,31,230,31,100,31,100,30,249,31,99,31,242,31,188,31,242,31,169,31,26,31,57,31,18,31,250,31,63,31,63,30,194,31,76,31,206,31,127,31,228,31,118,31,169,31,169,30,193,31,193,30,35,31,235,31,55,31,108,31,108,30,250,31,237,31,237,30,251,31,130,31,203,31,203,30,87,31,254,31,254,30,242,31,220,31,56,31,56,30,4,31,112,31,48,31,222,31,222,30,11,31,224,31,73,31,73,30,54,31,113,31,140,31,140,30,140,29,140,28,222,31,97,31,189,31,144,31,189,31,189,30,4,31,154,31,177,31,198,31,67,31,212,31,95,31,25,31,5,31,113,31,20,31,49,31,213,31,213,31,94,31,220,31,129,31,185,31,226,31,255,31,152,31,156,31,178,31,185,31,35,31,25,31,113,31,113,31,106,31,118,31,118,30,138,31,143,31,163,31,163,30,73,31,80,31,80,30,226,31,51,31,253,31,162,31,225,31,119,31,47,31,30,31,30,30,40,31,116,31,190,31,243,31,243,30,37,31,227,31,58,31,192,31,81,31,247,31,247,30,121,31,170,31,181,31,181,30,181,29,181,28,165,31,20,31,20,30,82,31,223,31,141,31,41,31,41,30,107,31,149,31,171,31,8,31,8,30,8,29,8,31,119,31,47,31,231,31,117,31,179,31,82,31,82,30,82,29,164,31,164,30,28,31,190,31,190,30,1,31,153,31,153,30,214,31,214,30,248,31,201,31,113,31,37,31,74,31,74,30,110,31,110,30,20,31,20,30,98,31,160,31,190,31,190,30,190,29,128,31,128,30,189,31,90,31,31,31,29,31,210,31,147,31,71,31,71,30,211,31,239,31,239,30,78,31,8,31,87,31,87,30,58,31,17,31,17,30,128,31,66,31,2,31,199,31,199,30,71,31,159,31,100,31,227,31,79,31,76,31,76,30,125,31,125,30,206,31,177,31,62,31,178,31,175,31,2,31,2,30,177,31,112,31,112,30,135,31,168,31,252,31,252,30,252,29,149,31,190,31,208,31,158,31,139,31,47,31,163,31,237,31,4,31,238,31,46,31,30,31,30,30,36,31,128,31,106,31,146,31,3,31,103,31,236,31,236,30,230,31,230,30,231,31,212,31,212,30,106,31,144,31,204,31,218,31,117,31,58,31,58,30,178,31,188,31,235,31,202,31,48,31,76,31,122,31,160,31,152,31,204,31,225,31,124,31,191,31,82,31,232,31,164,31,4,31,201,31,66,31,140,31,198,31,73,31,156,31,5,31,5,30,129,31,129,30,129,29,129,28,48,31,180,31,161,31,117,31,103,31,177,31,177,30,177,29,74,31,254,31,143,31,143,30,143,29,166,31,49,31,95,31,199,31,163,31,163,30,46,31,120,31,221,31,122,31,94,31,94,30,208,31,208,30,60,31,184,31,36,31,54,31,200,31,200,30,200,29,222,31,222,30,222,29,84,31,70,31,241,31,121,31,153,31,187,31,187,30,187,29,143,31,96,31,96,30,43,31,50,31,27,31,184,31,102,31,115,31,193,31,55,31,90,31,148,31,245,31,106,31,106,30,11,31,11,30,60,31,142,31,3,31,79,31,32,31,32,30,77,31,197,31,235,31,140,31,95,31,200,31,63,31,63,30,63,29,122,31,175,31,218,31,188,31,73,31,191,31,176,31,176,30,96,31,232,31,232,30,190,31,190,30,204,31,220,31,52,31,200,31,73,31,39,31,202,31,187,31,228,31,26,31,53,31,53,30,217,31,28,31,154,31,154,30,155,31,100,31,224,31,158,31,22,31,200,31,200,30,180,31,180,30,24,31,146,31,106,31,92,31,141,31,125,31,200,31,184,31,237,31,237,30,139,31,99,31,63,31,63,30,167,31,201,31,245,31,226,31,150,31,207,31,207,30,179,31,129,31,129,30,214,31,151,31,151,30,13,31,120,31,120,30,120,29,120,28,48,31,75,31,211,31,2,31,218,31,11,31,1,31,200,31,224,31,224,30,224,29,92,31,92,30,73,31,96,31,180,31,180,30,63,31,80,31,99,31,99,30,99,29,99,28,71,31,118,31,118,30,171,31,198,31,10,31,216,31,212,31,79,31,135,31,78,31,202,31,93,31,93,30,147,31,232,31,103,31,103,30,103,29,78,31,189,31,186,31,17,31,252,31,88,31,125,31,35,31,13,31,113,31,130,31,130,30,192,31,192,30,4,31,234,31,45,31,163,31,163,30,70,31,70,30,164,31,237,31,237,30,16,31,16,30,182,31,145,31,145,30,145,29,232,31,17,31,17,30,146,31,213,31,213,30,213,29,213,28,227,31,227,30,167,31,244,31,237,31,237,30,102,31,102,30,41,31,228,31,156,31,156,30,111,31,138,31,29,31,238,31,210,31,123,31,123,30,214,31,141,31,25,31,5,31,5,30,236,31,236,30,134,31,191,31,191,30,47,31,172,31,211,31,211,30,255,31,49,31,243,31,46,31,46,30,31,31,69,31,78,31,216,31,180,31,180,30,247,31,242,31,150,31,150,30,195,31,195,30,195,29,49,31,49,30,196,31,46,31,202,31,96,31,66,31,196,31,118,31,247,31,53,31,53,30,44,31,67,31,196,31,117,31,234,31,62,31,62,30,62,29);

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
