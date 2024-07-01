-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_515 is
end project_tb_515;

architecture project_tb_arch_515 of project_tb_515 is
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

constant SCENARIO_LENGTH : integer := 601;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (250,0,150,0,185,0,39,0,190,0,60,0,19,0,55,0,101,0,0,0,155,0,68,0,48,0,222,0,37,0,179,0,143,0,43,0,203,0,111,0,0,0,0,0,106,0,152,0,89,0,120,0,56,0,221,0,137,0,91,0,95,0,229,0,0,0,4,0,0,0,38,0,0,0,123,0,162,0,107,0,0,0,3,0,0,0,112,0,1,0,0,0,61,0,242,0,127,0,38,0,0,0,243,0,14,0,77,0,178,0,7,0,85,0,179,0,229,0,104,0,23,0,61,0,163,0,233,0,130,0,39,0,0,0,0,0,0,0,207,0,25,0,21,0,72,0,208,0,189,0,217,0,21,0,91,0,146,0,0,0,179,0,193,0,158,0,4,0,0,0,245,0,4,0,0,0,160,0,0,0,12,0,39,0,0,0,0,0,0,0,0,0,203,0,106,0,238,0,223,0,3,0,99,0,210,0,51,0,0,0,101,0,0,0,25,0,171,0,29,0,112,0,128,0,1,0,45,0,128,0,185,0,127,0,19,0,186,0,249,0,225,0,119,0,213,0,208,0,100,0,233,0,212,0,39,0,14,0,80,0,206,0,0,0,158,0,197,0,145,0,46,0,68,0,118,0,71,0,0,0,0,0,237,0,0,0,0,0,46,0,0,0,0,0,9,0,0,0,0,0,0,0,234,0,149,0,233,0,137,0,124,0,194,0,25,0,115,0,252,0,216,0,0,0,142,0,239,0,210,0,67,0,0,0,67,0,96,0,73,0,0,0,219,0,147,0,0,0,188,0,149,0,67,0,223,0,0,0,180,0,96,0,0,0,75,0,135,0,31,0,0,0,193,0,0,0,0,0,160,0,47,0,1,0,132,0,144,0,235,0,159,0,137,0,128,0,48,0,75,0,89,0,181,0,227,0,0,0,165,0,83,0,155,0,77,0,228,0,32,0,239,0,209,0,134,0,18,0,140,0,114,0,22,0,179,0,45,0,244,0,109,0,145,0,182,0,0,0,0,0,22,0,161,0,141,0,60,0,21,0,245,0,134,0,38,0,132,0,189,0,24,0,252,0,0,0,0,0,30,0,192,0,46,0,0,0,41,0,218,0,24,0,0,0,66,0,0,0,55,0,113,0,77,0,215,0,162,0,0,0,166,0,121,0,51,0,78,0,255,0,173,0,238,0,0,0,0,0,109,0,203,0,18,0,214,0,182,0,168,0,51,0,20,0,95,0,153,0,181,0,18,0,99,0,182,0,22,0,99,0,59,0,62,0,82,0,0,0,0,0,31,0,215,0,37,0,246,0,248,0,150,0,128,0,120,0,120,0,0,0,63,0,78,0,187,0,243,0,56,0,0,0,198,0,69,0,230,0,9,0,0,0,0,0,226,0,215,0,0,0,127,0,0,0,20,0,0,0,18,0,18,0,175,0,10,0,70,0,244,0,0,0,183,0,176,0,9,0,252,0,153,0,161,0,0,0,189,0,48,0,44,0,231,0,72,0,250,0,120,0,129,0,123,0,129,0,126,0,0,0,51,0,200,0,0,0,230,0,96,0,191,0,0,0,0,0,148,0,125,0,153,0,15,0,118,0,0,0,4,0,59,0,153,0,17,0,184,0,2,0,252,0,198,0,175,0,108,0,89,0,204,0,0,0,132,0,52,0,0,0,0,0,228,0,0,0,39,0,60,0,5,0,22,0,167,0,0,0,138,0,187,0,40,0,219,0,40,0,110,0,201,0,39,0,137,0,116,0,0,0,229,0,126,0,52,0,0,0,23,0,0,0,231,0,111,0,0,0,252,0,166,0,224,0,200,0,229,0,92,0,0,0,7,0,48,0,0,0,0,0,23,0,0,0,0,0,188,0,221,0,177,0,0,0,0,0,0,0,81,0,230,0,0,0,235,0,0,0,243,0,234,0,28,0,139,0,40,0,170,0,62,0,144,0,221,0,172,0,155,0,122,0,61,0,174,0,0,0,75,0,0,0,31,0,0,0,0,0,21,0,24,0,90,0,255,0,168,0,201,0,145,0,244,0,37,0,0,0,45,0,198,0,0,0,0,0,176,0,0,0,186,0,153,0,69,0,138,0,0,0,196,0,115,0,13,0,130,0,155,0,72,0,47,0,94,0,3,0,143,0,90,0,79,0,38,0,0,0,154,0,148,0,234,0,91,0,27,0,39,0,73,0,0,0,83,0,2,0,100,0,160,0,36,0,139,0,207,0,192,0,0,0,237,0,255,0,184,0,7,0,0,0,0,0,74,0,0,0,247,0,211,0,0,0,64,0,56,0,147,0,214,0,61,0,184,0,0,0,42,0,180,0,20,0,0,0,118,0,82,0,242,0,0,0,69,0,0,0,0,0,0,0,0,0,109,0,210,0,0,0,151,0,212,0,0,0,236,0,0,0,205,0,153,0,100,0,35,0,22,0,186,0,0,0,1,0,72,0,138,0,239,0,0,0,194,0,74,0,219,0,0,0,243,0,0,0,0,0,21,0,0,0,118,0,55,0,89,0,0,0,41,0,219,0,80,0,148,0,0,0,104,0,41,0,0,0,145,0,0,0,142,0,0,0,168,0,0,0,148,0,91,0,118,0,146,0,114,0,170,0,71,0,15,0,0,0,0,0,62,0,93,0,67,0,93,0,219,0,193,0,161,0,0,0,181,0,193,0,72,0,0,0,83,0,194,0,127,0,95,0,103,0);
signal scenario_full  : scenario_type := (250,31,150,31,185,31,39,31,190,31,60,31,19,31,55,31,101,31,101,30,155,31,68,31,48,31,222,31,37,31,179,31,143,31,43,31,203,31,111,31,111,30,111,29,106,31,152,31,89,31,120,31,56,31,221,31,137,31,91,31,95,31,229,31,229,30,4,31,4,30,38,31,38,30,123,31,162,31,107,31,107,30,3,31,3,30,112,31,1,31,1,30,61,31,242,31,127,31,38,31,38,30,243,31,14,31,77,31,178,31,7,31,85,31,179,31,229,31,104,31,23,31,61,31,163,31,233,31,130,31,39,31,39,30,39,29,39,28,207,31,25,31,21,31,72,31,208,31,189,31,217,31,21,31,91,31,146,31,146,30,179,31,193,31,158,31,4,31,4,30,245,31,4,31,4,30,160,31,160,30,12,31,39,31,39,30,39,29,39,28,39,27,203,31,106,31,238,31,223,31,3,31,99,31,210,31,51,31,51,30,101,31,101,30,25,31,171,31,29,31,112,31,128,31,1,31,45,31,128,31,185,31,127,31,19,31,186,31,249,31,225,31,119,31,213,31,208,31,100,31,233,31,212,31,39,31,14,31,80,31,206,31,206,30,158,31,197,31,145,31,46,31,68,31,118,31,71,31,71,30,71,29,237,31,237,30,237,29,46,31,46,30,46,29,9,31,9,30,9,29,9,28,234,31,149,31,233,31,137,31,124,31,194,31,25,31,115,31,252,31,216,31,216,30,142,31,239,31,210,31,67,31,67,30,67,31,96,31,73,31,73,30,219,31,147,31,147,30,188,31,149,31,67,31,223,31,223,30,180,31,96,31,96,30,75,31,135,31,31,31,31,30,193,31,193,30,193,29,160,31,47,31,1,31,132,31,144,31,235,31,159,31,137,31,128,31,48,31,75,31,89,31,181,31,227,31,227,30,165,31,83,31,155,31,77,31,228,31,32,31,239,31,209,31,134,31,18,31,140,31,114,31,22,31,179,31,45,31,244,31,109,31,145,31,182,31,182,30,182,29,22,31,161,31,141,31,60,31,21,31,245,31,134,31,38,31,132,31,189,31,24,31,252,31,252,30,252,29,30,31,192,31,46,31,46,30,41,31,218,31,24,31,24,30,66,31,66,30,55,31,113,31,77,31,215,31,162,31,162,30,166,31,121,31,51,31,78,31,255,31,173,31,238,31,238,30,238,29,109,31,203,31,18,31,214,31,182,31,168,31,51,31,20,31,95,31,153,31,181,31,18,31,99,31,182,31,22,31,99,31,59,31,62,31,82,31,82,30,82,29,31,31,215,31,37,31,246,31,248,31,150,31,128,31,120,31,120,31,120,30,63,31,78,31,187,31,243,31,56,31,56,30,198,31,69,31,230,31,9,31,9,30,9,29,226,31,215,31,215,30,127,31,127,30,20,31,20,30,18,31,18,31,175,31,10,31,70,31,244,31,244,30,183,31,176,31,9,31,252,31,153,31,161,31,161,30,189,31,48,31,44,31,231,31,72,31,250,31,120,31,129,31,123,31,129,31,126,31,126,30,51,31,200,31,200,30,230,31,96,31,191,31,191,30,191,29,148,31,125,31,153,31,15,31,118,31,118,30,4,31,59,31,153,31,17,31,184,31,2,31,252,31,198,31,175,31,108,31,89,31,204,31,204,30,132,31,52,31,52,30,52,29,228,31,228,30,39,31,60,31,5,31,22,31,167,31,167,30,138,31,187,31,40,31,219,31,40,31,110,31,201,31,39,31,137,31,116,31,116,30,229,31,126,31,52,31,52,30,23,31,23,30,231,31,111,31,111,30,252,31,166,31,224,31,200,31,229,31,92,31,92,30,7,31,48,31,48,30,48,29,23,31,23,30,23,29,188,31,221,31,177,31,177,30,177,29,177,28,81,31,230,31,230,30,235,31,235,30,243,31,234,31,28,31,139,31,40,31,170,31,62,31,144,31,221,31,172,31,155,31,122,31,61,31,174,31,174,30,75,31,75,30,31,31,31,30,31,29,21,31,24,31,90,31,255,31,168,31,201,31,145,31,244,31,37,31,37,30,45,31,198,31,198,30,198,29,176,31,176,30,186,31,153,31,69,31,138,31,138,30,196,31,115,31,13,31,130,31,155,31,72,31,47,31,94,31,3,31,143,31,90,31,79,31,38,31,38,30,154,31,148,31,234,31,91,31,27,31,39,31,73,31,73,30,83,31,2,31,100,31,160,31,36,31,139,31,207,31,192,31,192,30,237,31,255,31,184,31,7,31,7,30,7,29,74,31,74,30,247,31,211,31,211,30,64,31,56,31,147,31,214,31,61,31,184,31,184,30,42,31,180,31,20,31,20,30,118,31,82,31,242,31,242,30,69,31,69,30,69,29,69,28,69,27,109,31,210,31,210,30,151,31,212,31,212,30,236,31,236,30,205,31,153,31,100,31,35,31,22,31,186,31,186,30,1,31,72,31,138,31,239,31,239,30,194,31,74,31,219,31,219,30,243,31,243,30,243,29,21,31,21,30,118,31,55,31,89,31,89,30,41,31,219,31,80,31,148,31,148,30,104,31,41,31,41,30,145,31,145,30,142,31,142,30,168,31,168,30,148,31,91,31,118,31,146,31,114,31,170,31,71,31,15,31,15,30,15,29,62,31,93,31,67,31,93,31,219,31,193,31,161,31,161,30,181,31,193,31,72,31,72,30,83,31,194,31,127,31,95,31,103,31);

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
