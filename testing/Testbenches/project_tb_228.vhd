-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_228 is
end project_tb_228;

architecture project_tb_arch_228 of project_tb_228 is
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

constant SCENARIO_LENGTH : integer := 479;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (217,0,0,0,12,0,0,0,0,0,200,0,238,0,0,0,202,0,213,0,104,0,26,0,246,0,206,0,0,0,72,0,4,0,0,0,141,0,55,0,106,0,227,0,61,0,0,0,182,0,0,0,104,0,0,0,247,0,255,0,70,0,200,0,0,0,81,0,189,0,107,0,0,0,110,0,90,0,66,0,180,0,138,0,60,0,189,0,181,0,126,0,245,0,113,0,172,0,189,0,71,0,175,0,14,0,202,0,18,0,152,0,228,0,254,0,151,0,5,0,0,0,132,0,59,0,0,0,33,0,0,0,240,0,90,0,0,0,161,0,0,0,150,0,229,0,215,0,226,0,0,0,79,0,0,0,66,0,92,0,0,0,0,0,241,0,0,0,120,0,17,0,67,0,93,0,150,0,244,0,214,0,254,0,41,0,123,0,2,0,39,0,116,0,40,0,40,0,0,0,0,0,97,0,215,0,87,0,189,0,167,0,172,0,86,0,252,0,89,0,109,0,127,0,122,0,0,0,202,0,1,0,38,0,0,0,0,0,157,0,57,0,0,0,115,0,20,0,158,0,243,0,38,0,102,0,24,0,234,0,42,0,238,0,135,0,92,0,129,0,229,0,12,0,0,0,0,0,168,0,60,0,0,0,248,0,108,0,148,0,75,0,203,0,229,0,219,0,35,0,181,0,91,0,222,0,0,0,113,0,86,0,110,0,15,0,121,0,0,0,92,0,229,0,0,0,0,0,96,0,120,0,0,0,0,0,243,0,191,0,98,0,18,0,0,0,189,0,0,0,0,0,17,0,111,0,0,0,85,0,0,0,0,0,42,0,230,0,130,0,245,0,144,0,234,0,214,0,0,0,219,0,98,0,0,0,192,0,2,0,201,0,87,0,226,0,0,0,250,0,185,0,141,0,0,0,0,0,142,0,149,0,158,0,181,0,39,0,217,0,0,0,221,0,68,0,3,0,226,0,49,0,185,0,81,0,123,0,24,0,164,0,218,0,245,0,0,0,94,0,197,0,240,0,131,0,120,0,0,0,0,0,224,0,0,0,0,0,100,0,176,0,139,0,88,0,58,0,77,0,0,0,84,0,165,0,85,0,147,0,0,0,192,0,141,0,39,0,231,0,214,0,34,0,13,0,251,0,145,0,239,0,109,0,0,0,60,0,211,0,166,0,123,0,86,0,195,0,237,0,191,0,134,0,121,0,217,0,0,0,223,0,0,0,0,0,20,0,148,0,113,0,24,0,35,0,28,0,31,0,59,0,0,0,207,0,213,0,0,0,120,0,123,0,82,0,0,0,24,0,0,0,8,0,0,0,30,0,146,0,225,0,139,0,183,0,202,0,202,0,0,0,189,0,198,0,209,0,106,0,149,0,171,0,17,0,126,0,221,0,112,0,148,0,15,0,32,0,254,0,87,0,13,0,103,0,0,0,0,0,81,0,87,0,0,0,175,0,44,0,193,0,35,0,187,0,202,0,0,0,0,0,65,0,184,0,88,0,23,0,135,0,90,0,214,0,140,0,116,0,189,0,0,0,0,0,224,0,220,0,177,0,0,0,71,0,44,0,63,0,0,0,48,0,0,0,121,0,79,0,7,0,225,0,177,0,0,0,0,0,6,0,160,0,127,0,154,0,6,0,205,0,225,0,0,0,168,0,0,0,11,0,158,0,118,0,0,0,224,0,53,0,0,0,0,0,23,0,0,0,0,0,107,0,171,0,213,0,39,0,106,0,0,0,0,0,220,0,0,0,169,0,251,0,34,0,91,0,0,0,18,0,33,0,27,0,51,0,0,0,0,0,253,0,10,0,0,0,229,0,174,0,106,0,109,0,66,0,0,0,169,0,121,0,0,0,250,0,58,0,195,0,78,0,149,0,30,0,223,0,220,0,143,0,68,0,0,0,46,0,124,0,0,0,223,0,202,0,165,0,48,0,131,0,157,0,175,0,234,0,189,0,0,0,7,0,168,0,232,0,44,0,21,0,44,0,188,0,0,0,193,0,92,0,0,0,23,0,62,0,22,0,151,0,126,0,84,0,166,0,97,0,222,0,251,0,50,0,32,0,34,0,4,0,193,0,87,0,208,0,172,0,95,0,86,0,85,0,72,0,205,0,78,0,81,0,27,0,155,0,125,0,0,0,243,0,90,0);
signal scenario_full  : scenario_type := (217,31,217,30,12,31,12,30,12,29,200,31,238,31,238,30,202,31,213,31,104,31,26,31,246,31,206,31,206,30,72,31,4,31,4,30,141,31,55,31,106,31,227,31,61,31,61,30,182,31,182,30,104,31,104,30,247,31,255,31,70,31,200,31,200,30,81,31,189,31,107,31,107,30,110,31,90,31,66,31,180,31,138,31,60,31,189,31,181,31,126,31,245,31,113,31,172,31,189,31,71,31,175,31,14,31,202,31,18,31,152,31,228,31,254,31,151,31,5,31,5,30,132,31,59,31,59,30,33,31,33,30,240,31,90,31,90,30,161,31,161,30,150,31,229,31,215,31,226,31,226,30,79,31,79,30,66,31,92,31,92,30,92,29,241,31,241,30,120,31,17,31,67,31,93,31,150,31,244,31,214,31,254,31,41,31,123,31,2,31,39,31,116,31,40,31,40,31,40,30,40,29,97,31,215,31,87,31,189,31,167,31,172,31,86,31,252,31,89,31,109,31,127,31,122,31,122,30,202,31,1,31,38,31,38,30,38,29,157,31,57,31,57,30,115,31,20,31,158,31,243,31,38,31,102,31,24,31,234,31,42,31,238,31,135,31,92,31,129,31,229,31,12,31,12,30,12,29,168,31,60,31,60,30,248,31,108,31,148,31,75,31,203,31,229,31,219,31,35,31,181,31,91,31,222,31,222,30,113,31,86,31,110,31,15,31,121,31,121,30,92,31,229,31,229,30,229,29,96,31,120,31,120,30,120,29,243,31,191,31,98,31,18,31,18,30,189,31,189,30,189,29,17,31,111,31,111,30,85,31,85,30,85,29,42,31,230,31,130,31,245,31,144,31,234,31,214,31,214,30,219,31,98,31,98,30,192,31,2,31,201,31,87,31,226,31,226,30,250,31,185,31,141,31,141,30,141,29,142,31,149,31,158,31,181,31,39,31,217,31,217,30,221,31,68,31,3,31,226,31,49,31,185,31,81,31,123,31,24,31,164,31,218,31,245,31,245,30,94,31,197,31,240,31,131,31,120,31,120,30,120,29,224,31,224,30,224,29,100,31,176,31,139,31,88,31,58,31,77,31,77,30,84,31,165,31,85,31,147,31,147,30,192,31,141,31,39,31,231,31,214,31,34,31,13,31,251,31,145,31,239,31,109,31,109,30,60,31,211,31,166,31,123,31,86,31,195,31,237,31,191,31,134,31,121,31,217,31,217,30,223,31,223,30,223,29,20,31,148,31,113,31,24,31,35,31,28,31,31,31,59,31,59,30,207,31,213,31,213,30,120,31,123,31,82,31,82,30,24,31,24,30,8,31,8,30,30,31,146,31,225,31,139,31,183,31,202,31,202,31,202,30,189,31,198,31,209,31,106,31,149,31,171,31,17,31,126,31,221,31,112,31,148,31,15,31,32,31,254,31,87,31,13,31,103,31,103,30,103,29,81,31,87,31,87,30,175,31,44,31,193,31,35,31,187,31,202,31,202,30,202,29,65,31,184,31,88,31,23,31,135,31,90,31,214,31,140,31,116,31,189,31,189,30,189,29,224,31,220,31,177,31,177,30,71,31,44,31,63,31,63,30,48,31,48,30,121,31,79,31,7,31,225,31,177,31,177,30,177,29,6,31,160,31,127,31,154,31,6,31,205,31,225,31,225,30,168,31,168,30,11,31,158,31,118,31,118,30,224,31,53,31,53,30,53,29,23,31,23,30,23,29,107,31,171,31,213,31,39,31,106,31,106,30,106,29,220,31,220,30,169,31,251,31,34,31,91,31,91,30,18,31,33,31,27,31,51,31,51,30,51,29,253,31,10,31,10,30,229,31,174,31,106,31,109,31,66,31,66,30,169,31,121,31,121,30,250,31,58,31,195,31,78,31,149,31,30,31,223,31,220,31,143,31,68,31,68,30,46,31,124,31,124,30,223,31,202,31,165,31,48,31,131,31,157,31,175,31,234,31,189,31,189,30,7,31,168,31,232,31,44,31,21,31,44,31,188,31,188,30,193,31,92,31,92,30,23,31,62,31,22,31,151,31,126,31,84,31,166,31,97,31,222,31,251,31,50,31,32,31,34,31,4,31,193,31,87,31,208,31,172,31,95,31,86,31,85,31,72,31,205,31,78,31,81,31,27,31,155,31,125,31,125,30,243,31,90,31);

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
