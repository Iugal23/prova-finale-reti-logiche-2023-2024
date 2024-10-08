-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_50 is
end project_tb_50;

architecture project_tb_arch_50 of project_tb_50 is
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

constant SCENARIO_LENGTH : integer := 637;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (5,0,214,0,253,0,186,0,73,0,0,0,3,0,13,0,58,0,134,0,151,0,227,0,111,0,0,0,202,0,52,0,34,0,0,0,0,0,65,0,61,0,102,0,210,0,153,0,0,0,20,0,64,0,0,0,180,0,0,0,30,0,26,0,94,0,22,0,157,0,180,0,182,0,203,0,24,0,144,0,29,0,100,0,197,0,0,0,193,0,0,0,218,0,0,0,71,0,103,0,90,0,62,0,136,0,17,0,51,0,95,0,107,0,146,0,166,0,172,0,0,0,255,0,24,0,0,0,22,0,135,0,157,0,10,0,35,0,27,0,74,0,0,0,44,0,147,0,164,0,66,0,67,0,0,0,15,0,14,0,17,0,40,0,0,0,166,0,228,0,2,0,51,0,214,0,184,0,242,0,0,0,237,0,0,0,242,0,234,0,74,0,157,0,232,0,211,0,203,0,6,0,92,0,128,0,51,0,43,0,8,0,127,0,45,0,188,0,228,0,154,0,60,0,137,0,0,0,243,0,118,0,89,0,48,0,159,0,0,0,93,0,0,0,45,0,218,0,57,0,116,0,76,0,82,0,81,0,122,0,0,0,114,0,187,0,105,0,94,0,0,0,245,0,11,0,137,0,0,0,245,0,0,0,228,0,177,0,0,0,0,0,218,0,0,0,135,0,0,0,117,0,73,0,237,0,232,0,0,0,8,0,184,0,18,0,0,0,249,0,6,0,116,0,143,0,61,0,161,0,137,0,0,0,47,0,210,0,246,0,243,0,17,0,0,0,0,0,170,0,216,0,0,0,120,0,125,0,0,0,124,0,0,0,99,0,93,0,191,0,110,0,0,0,73,0,238,0,207,0,163,0,168,0,200,0,226,0,114,0,137,0,42,0,132,0,0,0,0,0,0,0,11,0,134,0,0,0,52,0,72,0,219,0,157,0,11,0,0,0,25,0,187,0,0,0,104,0,158,0,152,0,206,0,12,0,65,0,73,0,0,0,0,0,107,0,184,0,87,0,0,0,163,0,0,0,171,0,2,0,0,0,23,0,23,0,219,0,236,0,0,0,121,0,39,0,99,0,222,0,236,0,241,0,162,0,221,0,142,0,52,0,201,0,0,0,32,0,250,0,198,0,22,0,80,0,103,0,46,0,83,0,124,0,0,0,210,0,172,0,0,0,0,0,251,0,244,0,62,0,0,0,0,0,115,0,100,0,0,0,207,0,99,0,247,0,0,0,8,0,63,0,222,0,165,0,5,0,238,0,0,0,60,0,0,0,235,0,56,0,77,0,89,0,186,0,13,0,111,0,0,0,85,0,205,0,0,0,82,0,56,0,26,0,0,0,129,0,0,0,153,0,211,0,143,0,0,0,67,0,161,0,106,0,31,0,244,0,0,0,0,0,221,0,0,0,14,0,62,0,195,0,63,0,213,0,75,0,96,0,159,0,60,0,20,0,182,0,246,0,0,0,0,0,27,0,57,0,0,0,0,0,69,0,0,0,129,0,232,0,182,0,204,0,208,0,102,0,103,0,137,0,0,0,50,0,60,0,209,0,0,0,62,0,142,0,0,0,10,0,0,0,252,0,212,0,20,0,0,0,0,0,0,0,0,0,0,0,208,0,217,0,220,0,55,0,72,0,132,0,7,0,142,0,60,0,130,0,83,0,109,0,237,0,181,0,49,0,175,0,0,0,145,0,146,0,36,0,45,0,0,0,16,0,226,0,191,0,68,0,187,0,148,0,189,0,0,0,54,0,225,0,116,0,0,0,125,0,131,0,168,0,66,0,178,0,224,0,35,0,203,0,94,0,89,0,104,0,245,0,35,0,87,0,143,0,0,0,15,0,154,0,0,0,0,0,0,0,143,0,236,0,118,0,0,0,0,0,12,0,0,0,48,0,0,0,191,0,192,0,245,0,157,0,0,0,221,0,60,0,117,0,121,0,253,0,28,0,33,0,209,0,132,0,154,0,197,0,105,0,42,0,136,0,201,0,0,0,11,0,19,0,231,0,194,0,25,0,241,0,0,0,0,0,82,0,0,0,123,0,104,0,72,0,9,0,254,0,62,0,133,0,216,0,45,0,15,0,245,0,189,0,209,0,177,0,64,0,16,0,181,0,0,0,160,0,147,0,0,0,83,0,0,0,0,0,142,0,34,0,68,0,63,0,72,0,195,0,0,0,89,0,137,0,4,0,33,0,191,0,238,0,233,0,5,0,166,0,110,0,151,0,223,0,0,0,0,0,79,0,214,0,119,0,98,0,200,0,0,0,0,0,88,0,0,0,230,0,210,0,0,0,0,0,252,0,0,0,36,0,144,0,137,0,0,0,79,0,44,0,85,0,30,0,193,0,66,0,67,0,138,0,41,0,168,0,0,0,0,0,163,0,0,0,230,0,163,0,61,0,200,0,96,0,0,0,62,0,179,0,0,0,169,0,120,0,0,0,55,0,59,0,108,0,0,0,105,0,9,0,22,0,204,0,144,0,121,0,229,0,206,0,0,0,142,0,182,0,223,0,19,0,222,0,0,0,118,0,232,0,25,0,71,0,12,0,160,0,65,0,72,0,215,0,15,0,68,0,197,0,0,0,222,0,227,0,22,0,250,0,105,0,244,0,184,0,45,0,27,0,204,0,192,0,0,0,196,0,171,0,117,0,172,0,152,0,108,0,194,0,215,0,0,0,38,0,132,0,189,0,235,0,118,0,114,0,102,0,3,0,254,0,0,0,90,0,103,0,173,0,201,0,65,0,18,0,174,0,0,0,159,0,65,0,177,0,123,0,111,0,22,0,180,0,9,0,112,0,161,0,222,0,57,0,89,0,0,0,0,0,0,0,41,0,0,0,54,0,200,0,129,0,67,0);
signal scenario_full  : scenario_type := (5,31,214,31,253,31,186,31,73,31,73,30,3,31,13,31,58,31,134,31,151,31,227,31,111,31,111,30,202,31,52,31,34,31,34,30,34,29,65,31,61,31,102,31,210,31,153,31,153,30,20,31,64,31,64,30,180,31,180,30,30,31,26,31,94,31,22,31,157,31,180,31,182,31,203,31,24,31,144,31,29,31,100,31,197,31,197,30,193,31,193,30,218,31,218,30,71,31,103,31,90,31,62,31,136,31,17,31,51,31,95,31,107,31,146,31,166,31,172,31,172,30,255,31,24,31,24,30,22,31,135,31,157,31,10,31,35,31,27,31,74,31,74,30,44,31,147,31,164,31,66,31,67,31,67,30,15,31,14,31,17,31,40,31,40,30,166,31,228,31,2,31,51,31,214,31,184,31,242,31,242,30,237,31,237,30,242,31,234,31,74,31,157,31,232,31,211,31,203,31,6,31,92,31,128,31,51,31,43,31,8,31,127,31,45,31,188,31,228,31,154,31,60,31,137,31,137,30,243,31,118,31,89,31,48,31,159,31,159,30,93,31,93,30,45,31,218,31,57,31,116,31,76,31,82,31,81,31,122,31,122,30,114,31,187,31,105,31,94,31,94,30,245,31,11,31,137,31,137,30,245,31,245,30,228,31,177,31,177,30,177,29,218,31,218,30,135,31,135,30,117,31,73,31,237,31,232,31,232,30,8,31,184,31,18,31,18,30,249,31,6,31,116,31,143,31,61,31,161,31,137,31,137,30,47,31,210,31,246,31,243,31,17,31,17,30,17,29,170,31,216,31,216,30,120,31,125,31,125,30,124,31,124,30,99,31,93,31,191,31,110,31,110,30,73,31,238,31,207,31,163,31,168,31,200,31,226,31,114,31,137,31,42,31,132,31,132,30,132,29,132,28,11,31,134,31,134,30,52,31,72,31,219,31,157,31,11,31,11,30,25,31,187,31,187,30,104,31,158,31,152,31,206,31,12,31,65,31,73,31,73,30,73,29,107,31,184,31,87,31,87,30,163,31,163,30,171,31,2,31,2,30,23,31,23,31,219,31,236,31,236,30,121,31,39,31,99,31,222,31,236,31,241,31,162,31,221,31,142,31,52,31,201,31,201,30,32,31,250,31,198,31,22,31,80,31,103,31,46,31,83,31,124,31,124,30,210,31,172,31,172,30,172,29,251,31,244,31,62,31,62,30,62,29,115,31,100,31,100,30,207,31,99,31,247,31,247,30,8,31,63,31,222,31,165,31,5,31,238,31,238,30,60,31,60,30,235,31,56,31,77,31,89,31,186,31,13,31,111,31,111,30,85,31,205,31,205,30,82,31,56,31,26,31,26,30,129,31,129,30,153,31,211,31,143,31,143,30,67,31,161,31,106,31,31,31,244,31,244,30,244,29,221,31,221,30,14,31,62,31,195,31,63,31,213,31,75,31,96,31,159,31,60,31,20,31,182,31,246,31,246,30,246,29,27,31,57,31,57,30,57,29,69,31,69,30,129,31,232,31,182,31,204,31,208,31,102,31,103,31,137,31,137,30,50,31,60,31,209,31,209,30,62,31,142,31,142,30,10,31,10,30,252,31,212,31,20,31,20,30,20,29,20,28,20,27,20,26,208,31,217,31,220,31,55,31,72,31,132,31,7,31,142,31,60,31,130,31,83,31,109,31,237,31,181,31,49,31,175,31,175,30,145,31,146,31,36,31,45,31,45,30,16,31,226,31,191,31,68,31,187,31,148,31,189,31,189,30,54,31,225,31,116,31,116,30,125,31,131,31,168,31,66,31,178,31,224,31,35,31,203,31,94,31,89,31,104,31,245,31,35,31,87,31,143,31,143,30,15,31,154,31,154,30,154,29,154,28,143,31,236,31,118,31,118,30,118,29,12,31,12,30,48,31,48,30,191,31,192,31,245,31,157,31,157,30,221,31,60,31,117,31,121,31,253,31,28,31,33,31,209,31,132,31,154,31,197,31,105,31,42,31,136,31,201,31,201,30,11,31,19,31,231,31,194,31,25,31,241,31,241,30,241,29,82,31,82,30,123,31,104,31,72,31,9,31,254,31,62,31,133,31,216,31,45,31,15,31,245,31,189,31,209,31,177,31,64,31,16,31,181,31,181,30,160,31,147,31,147,30,83,31,83,30,83,29,142,31,34,31,68,31,63,31,72,31,195,31,195,30,89,31,137,31,4,31,33,31,191,31,238,31,233,31,5,31,166,31,110,31,151,31,223,31,223,30,223,29,79,31,214,31,119,31,98,31,200,31,200,30,200,29,88,31,88,30,230,31,210,31,210,30,210,29,252,31,252,30,36,31,144,31,137,31,137,30,79,31,44,31,85,31,30,31,193,31,66,31,67,31,138,31,41,31,168,31,168,30,168,29,163,31,163,30,230,31,163,31,61,31,200,31,96,31,96,30,62,31,179,31,179,30,169,31,120,31,120,30,55,31,59,31,108,31,108,30,105,31,9,31,22,31,204,31,144,31,121,31,229,31,206,31,206,30,142,31,182,31,223,31,19,31,222,31,222,30,118,31,232,31,25,31,71,31,12,31,160,31,65,31,72,31,215,31,15,31,68,31,197,31,197,30,222,31,227,31,22,31,250,31,105,31,244,31,184,31,45,31,27,31,204,31,192,31,192,30,196,31,171,31,117,31,172,31,152,31,108,31,194,31,215,31,215,30,38,31,132,31,189,31,235,31,118,31,114,31,102,31,3,31,254,31,254,30,90,31,103,31,173,31,201,31,65,31,18,31,174,31,174,30,159,31,65,31,177,31,123,31,111,31,22,31,180,31,9,31,112,31,161,31,222,31,57,31,89,31,89,30,89,29,89,28,41,31,41,30,54,31,200,31,129,31,67,31);

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
