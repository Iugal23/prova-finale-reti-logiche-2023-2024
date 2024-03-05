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

constant SCENARIO_LENGTH : integer := 682;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (113,0,194,0,119,0,133,0,0,0,203,0,109,0,114,0,181,0,28,0,177,0,87,0,92,0,69,0,254,0,109,0,0,0,212,0,240,0,177,0,56,0,182,0,9,0,226,0,255,0,69,0,201,0,16,0,116,0,36,0,158,0,0,0,89,0,229,0,121,0,66,0,0,0,219,0,0,0,109,0,157,0,203,0,236,0,0,0,224,0,209,0,166,0,253,0,141,0,77,0,58,0,144,0,53,0,0,0,253,0,182,0,13,0,0,0,142,0,254,0,146,0,191,0,193,0,2,0,90,0,0,0,100,0,138,0,231,0,86,0,254,0,0,0,98,0,0,0,71,0,105,0,144,0,241,0,60,0,7,0,144,0,236,0,22,0,91,0,175,0,225,0,11,0,0,0,32,0,218,0,59,0,196,0,29,0,253,0,231,0,93,0,187,0,89,0,115,0,27,0,51,0,2,0,13,0,22,0,18,0,88,0,160,0,0,0,13,0,245,0,198,0,84,0,87,0,199,0,234,0,78,0,200,0,207,0,200,0,55,0,22,0,63,0,131,0,16,0,62,0,239,0,150,0,83,0,0,0,0,0,0,0,248,0,198,0,215,0,214,0,230,0,232,0,0,0,122,0,91,0,143,0,62,0,0,0,0,0,103,0,55,0,25,0,13,0,241,0,125,0,110,0,53,0,182,0,2,0,40,0,176,0,0,0,20,0,145,0,131,0,52,0,131,0,0,0,241,0,50,0,162,0,250,0,72,0,36,0,147,0,83,0,42,0,81,0,137,0,230,0,0,0,242,0,62,0,0,0,130,0,137,0,206,0,187,0,0,0,0,0,0,0,146,0,0,0,124,0,115,0,70,0,26,0,29,0,0,0,0,0,78,0,185,0,0,0,214,0,11,0,243,0,171,0,0,0,0,0,0,0,43,0,0,0,67,0,205,0,127,0,81,0,120,0,81,0,220,0,29,0,19,0,205,0,149,0,81,0,145,0,124,0,0,0,11,0,205,0,188,0,141,0,161,0,81,0,217,0,0,0,104,0,0,0,126,0,114,0,109,0,2,0,0,0,242,0,33,0,0,0,22,0,9,0,140,0,46,0,0,0,149,0,90,0,182,0,157,0,124,0,0,0,18,0,35,0,80,0,130,0,199,0,22,0,10,0,45,0,9,0,24,0,184,0,207,0,183,0,167,0,0,0,21,0,76,0,98,0,33,0,0,0,76,0,55,0,178,0,165,0,0,0,163,0,226,0,174,0,93,0,190,0,182,0,200,0,224,0,0,0,0,0,216,0,51,0,210,0,170,0,166,0,0,0,81,0,248,0,94,0,0,0,244,0,141,0,205,0,0,0,129,0,29,0,250,0,0,0,83,0,35,0,218,0,193,0,29,0,175,0,55,0,26,0,0,0,156,0,191,0,158,0,182,0,0,0,2,0,222,0,61,0,8,0,92,0,186,0,187,0,35,0,0,0,7,0,66,0,255,0,102,0,126,0,81,0,13,0,44,0,149,0,226,0,215,0,223,0,65,0,0,0,79,0,0,0,61,0,18,0,171,0,24,0,73,0,133,0,145,0,188,0,134,0,28,0,193,0,49,0,123,0,223,0,36,0,43,0,235,0,79,0,0,0,0,0,26,0,240,0,87,0,137,0,164,0,120,0,251,0,211,0,0,0,17,0,0,0,35,0,70,0,52,0,12,0,0,0,4,0,131,0,251,0,0,0,149,0,0,0,90,0,246,0,71,0,234,0,17,0,76,0,20,0,166,0,85,0,254,0,237,0,105,0,79,0,134,0,247,0,116,0,17,0,0,0,66,0,206,0,0,0,1,0,113,0,0,0,198,0,189,0,0,0,229,0,86,0,185,0,109,0,188,0,133,0,34,0,19,0,0,0,215,0,0,0,102,0,170,0,180,0,186,0,8,0,30,0,162,0,0,0,164,0,80,0,97,0,231,0,170,0,18,0,15,0,189,0,19,0,0,0,98,0,85,0,90,0,68,0,0,0,67,0,184,0,157,0,0,0,0,0,70,0,64,0,82,0,22,0,239,0,140,0,56,0,134,0,55,0,41,0,173,0,243,0,180,0,196,0,220,0,106,0,177,0,12,0,219,0,178,0,0,0,0,0,36,0,132,0,94,0,200,0,119,0,164,0,0,0,149,0,41,0,200,0,161,0,214,0,197,0,218,0,0,0,101,0,0,0,0,0,202,0,23,0,205,0,0,0,41,0,33,0,156,0,237,0,40,0,86,0,153,0,91,0,252,0,49,0,201,0,77,0,238,0,242,0,69,0,83,0,211,0,254,0,81,0,73,0,144,0,74,0,0,0,12,0,115,0,234,0,127,0,220,0,154,0,104,0,125,0,180,0,9,0,44,0,151,0,84,0,0,0,136,0,138,0,17,0,149,0,137,0,158,0,30,0,79,0,148,0,0,0,32,0,168,0,202,0,117,0,0,0,80,0,0,0,64,0,176,0,4,0,0,0,166,0,87,0,75,0,155,0,200,0,124,0,102,0,21,0,147,0,133,0,0,0,104,0,68,0,213,0,76,0,0,0,121,0,121,0,0,0,187,0,226,0,135,0,163,0,1,0,213,0,176,0,238,0,0,0,102,0,221,0,102,0,46,0,122,0,237,0,0,0,203,0,29,0,0,0,138,0,182,0,84,0,0,0,114,0,0,0,67,0,0,0,11,0,138,0,198,0,222,0,0,0,63,0,109,0,168,0,0,0,186,0,80,0,173,0,251,0,217,0,91,0,0,0,153,0,125,0,66,0,71,0,12,0,144,0,113,0,6,0,178,0,137,0,139,0,171,0,132,0,146,0,110,0,114,0,20,0,107,0,0,0,170,0,94,0,90,0,198,0,228,0,0,0,47,0,87,0,197,0,29,0,38,0,35,0,21,0,48,0,0,0,184,0,73,0,0,0,134,0,81,0,116,0,40,0,174,0,235,0,189,0,54,0,238,0,84,0,0,0,163,0,62,0,45,0,55,0,200,0,19,0,171,0,176,0,171,0,72,0,119,0,0,0,125,0,42,0,158,0,118,0,52,0,142,0,125,0);
signal scenario_full  : scenario_type := (113,31,194,31,119,31,133,31,133,30,203,31,109,31,114,31,181,31,28,31,177,31,87,31,92,31,69,31,254,31,109,31,109,30,212,31,240,31,177,31,56,31,182,31,9,31,226,31,255,31,69,31,201,31,16,31,116,31,36,31,158,31,158,30,89,31,229,31,121,31,66,31,66,30,219,31,219,30,109,31,157,31,203,31,236,31,236,30,224,31,209,31,166,31,253,31,141,31,77,31,58,31,144,31,53,31,53,30,253,31,182,31,13,31,13,30,142,31,254,31,146,31,191,31,193,31,2,31,90,31,90,30,100,31,138,31,231,31,86,31,254,31,254,30,98,31,98,30,71,31,105,31,144,31,241,31,60,31,7,31,144,31,236,31,22,31,91,31,175,31,225,31,11,31,11,30,32,31,218,31,59,31,196,31,29,31,253,31,231,31,93,31,187,31,89,31,115,31,27,31,51,31,2,31,13,31,22,31,18,31,88,31,160,31,160,30,13,31,245,31,198,31,84,31,87,31,199,31,234,31,78,31,200,31,207,31,200,31,55,31,22,31,63,31,131,31,16,31,62,31,239,31,150,31,83,31,83,30,83,29,83,28,248,31,198,31,215,31,214,31,230,31,232,31,232,30,122,31,91,31,143,31,62,31,62,30,62,29,103,31,55,31,25,31,13,31,241,31,125,31,110,31,53,31,182,31,2,31,40,31,176,31,176,30,20,31,145,31,131,31,52,31,131,31,131,30,241,31,50,31,162,31,250,31,72,31,36,31,147,31,83,31,42,31,81,31,137,31,230,31,230,30,242,31,62,31,62,30,130,31,137,31,206,31,187,31,187,30,187,29,187,28,146,31,146,30,124,31,115,31,70,31,26,31,29,31,29,30,29,29,78,31,185,31,185,30,214,31,11,31,243,31,171,31,171,30,171,29,171,28,43,31,43,30,67,31,205,31,127,31,81,31,120,31,81,31,220,31,29,31,19,31,205,31,149,31,81,31,145,31,124,31,124,30,11,31,205,31,188,31,141,31,161,31,81,31,217,31,217,30,104,31,104,30,126,31,114,31,109,31,2,31,2,30,242,31,33,31,33,30,22,31,9,31,140,31,46,31,46,30,149,31,90,31,182,31,157,31,124,31,124,30,18,31,35,31,80,31,130,31,199,31,22,31,10,31,45,31,9,31,24,31,184,31,207,31,183,31,167,31,167,30,21,31,76,31,98,31,33,31,33,30,76,31,55,31,178,31,165,31,165,30,163,31,226,31,174,31,93,31,190,31,182,31,200,31,224,31,224,30,224,29,216,31,51,31,210,31,170,31,166,31,166,30,81,31,248,31,94,31,94,30,244,31,141,31,205,31,205,30,129,31,29,31,250,31,250,30,83,31,35,31,218,31,193,31,29,31,175,31,55,31,26,31,26,30,156,31,191,31,158,31,182,31,182,30,2,31,222,31,61,31,8,31,92,31,186,31,187,31,35,31,35,30,7,31,66,31,255,31,102,31,126,31,81,31,13,31,44,31,149,31,226,31,215,31,223,31,65,31,65,30,79,31,79,30,61,31,18,31,171,31,24,31,73,31,133,31,145,31,188,31,134,31,28,31,193,31,49,31,123,31,223,31,36,31,43,31,235,31,79,31,79,30,79,29,26,31,240,31,87,31,137,31,164,31,120,31,251,31,211,31,211,30,17,31,17,30,35,31,70,31,52,31,12,31,12,30,4,31,131,31,251,31,251,30,149,31,149,30,90,31,246,31,71,31,234,31,17,31,76,31,20,31,166,31,85,31,254,31,237,31,105,31,79,31,134,31,247,31,116,31,17,31,17,30,66,31,206,31,206,30,1,31,113,31,113,30,198,31,189,31,189,30,229,31,86,31,185,31,109,31,188,31,133,31,34,31,19,31,19,30,215,31,215,30,102,31,170,31,180,31,186,31,8,31,30,31,162,31,162,30,164,31,80,31,97,31,231,31,170,31,18,31,15,31,189,31,19,31,19,30,98,31,85,31,90,31,68,31,68,30,67,31,184,31,157,31,157,30,157,29,70,31,64,31,82,31,22,31,239,31,140,31,56,31,134,31,55,31,41,31,173,31,243,31,180,31,196,31,220,31,106,31,177,31,12,31,219,31,178,31,178,30,178,29,36,31,132,31,94,31,200,31,119,31,164,31,164,30,149,31,41,31,200,31,161,31,214,31,197,31,218,31,218,30,101,31,101,30,101,29,202,31,23,31,205,31,205,30,41,31,33,31,156,31,237,31,40,31,86,31,153,31,91,31,252,31,49,31,201,31,77,31,238,31,242,31,69,31,83,31,211,31,254,31,81,31,73,31,144,31,74,31,74,30,12,31,115,31,234,31,127,31,220,31,154,31,104,31,125,31,180,31,9,31,44,31,151,31,84,31,84,30,136,31,138,31,17,31,149,31,137,31,158,31,30,31,79,31,148,31,148,30,32,31,168,31,202,31,117,31,117,30,80,31,80,30,64,31,176,31,4,31,4,30,166,31,87,31,75,31,155,31,200,31,124,31,102,31,21,31,147,31,133,31,133,30,104,31,68,31,213,31,76,31,76,30,121,31,121,31,121,30,187,31,226,31,135,31,163,31,1,31,213,31,176,31,238,31,238,30,102,31,221,31,102,31,46,31,122,31,237,31,237,30,203,31,29,31,29,30,138,31,182,31,84,31,84,30,114,31,114,30,67,31,67,30,11,31,138,31,198,31,222,31,222,30,63,31,109,31,168,31,168,30,186,31,80,31,173,31,251,31,217,31,91,31,91,30,153,31,125,31,66,31,71,31,12,31,144,31,113,31,6,31,178,31,137,31,139,31,171,31,132,31,146,31,110,31,114,31,20,31,107,31,107,30,170,31,94,31,90,31,198,31,228,31,228,30,47,31,87,31,197,31,29,31,38,31,35,31,21,31,48,31,48,30,184,31,73,31,73,30,134,31,81,31,116,31,40,31,174,31,235,31,189,31,54,31,238,31,84,31,84,30,163,31,62,31,45,31,55,31,200,31,19,31,171,31,176,31,171,31,72,31,119,31,119,30,125,31,42,31,158,31,118,31,52,31,142,31,125,31);

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
